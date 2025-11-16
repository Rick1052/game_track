import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_compress/video_compress.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/video_repository.dart';
import '../../domain/models/video_model.dart';
import '../../core/constants/firestore_collections.dart';
import '../../core/constants/app_constants.dart';

class VideoRepositoryImpl implements VideoRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final Uuid _uuid = const Uuid();

  VideoRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _storage = storage,
        _auth = auth;

  @override
  Stream<List<VideoModel>> getVideos({
    int limit = 10,
    DateTime? startAfter,
    String? orderBy = 'createdAt',
  }) {
    Query query = _firestore
        .collection(FirestoreCollections.videos)
        .orderBy(orderBy ?? 'createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfter([Timestamp.fromDate(startAfter)]);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return VideoModel.fromJson({
              'id': doc.id,
              ...data,
            });
          })
          .toList();
    });
  }

  @override
  Future<VideoModel> getVideoById(String videoId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.videos)
        .doc(videoId)
        .get();

    if (!doc.exists) {
      throw Exception('Vídeo não encontrado');
    }

    return VideoModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  @override
  Future<List<VideoModel>> getUserVideos(String userId) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.videos)
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => VideoModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<VideoModel> uploadVideo({
    required String filePath,
    required String title,
    String? description,
    String? game,
    bool compress = false,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    String? videoId;
    String? videoUrl;
    
    try {
      String finalPath = filePath;
      
      // Comprimir vídeo se solicitado
      if (compress) {
        final compressed = await VideoCompress.compressVideo(
          filePath,
          quality: VideoQuality.MediumQuality,
        );
        if (compressed?.path != null) {
          finalPath = compressed!.path!;
        }
      }

      videoId = _uuid.v4();
      final videoFile = File(finalPath);
      
      // Verificar se o arquivo existe
      if (!await videoFile.exists()) {
        throw Exception('Arquivo de vídeo não encontrado: $finalPath');
      }
      
      // Verificar tamanho do arquivo (max 100MB conforme regras do Storage)
      final fileSize = await videoFile.length();
      const maxSize = 100 * 1024 * 1024; // 100MB
      if (fileSize > maxSize) {
        throw Exception('Vídeo muito grande. Tamanho máximo: 100MB. Tamanho atual: ${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB');
      }
      
      final videoFileName = '$videoId.mp4';

      // Upload do vídeo
      final videoRef = _storage
          .ref()
          .child(AppConstants.videosStoragePath)
          .child(videoFileName);

      // Upload do vídeo
      final uploadTask = videoRef.putFile(videoFile);
      
      // Aguardar o upload completar
      try {
        await uploadTask;
      } catch (uploadError) {
        throw Exception('Erro durante o upload do vídeo: $uploadError');
      }
      
      // Aguardar um tempo inicial para o Firebase Storage processar o arquivo
      // Arquivos grandes podem precisar de mais tempo
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // Obter a URL de download com retry robusto
      // O Firebase Storage pode levar tempo para disponibilizar o arquivo
      int retries = 10;
      int delayMs = 2000;
      Exception? lastError;
      bool success = false;
      
      while (retries > 0 && !success) {
        try {
          // Tentar obter a URL
          videoUrl = await videoRef.getDownloadURL();
          
          // Verificar se a URL é válida
          if (videoUrl.isNotEmpty) {
            // Verificar se a URL é acessível fazendo uma verificação adicional
            try {
              final metadata = await videoRef.getMetadata();
              if (metadata.size != null && metadata.size! > 0) {
                success = true;
                break; // Sucesso confirmado!
              }
            } catch (_) {
              // Metadata não disponível ainda, mas URL foi obtida
              success = true;
              break;
            }
          }
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
          retries--;
          
          if (retries == 0) {
            // Última tentativa falhou - fazer diagnóstico completo
            try {
              final metadata = await videoRef.getMetadata();
              // Arquivo existe mas não conseguimos a URL
              final sizeInfo = metadata.size != null ? '${metadata.size} bytes' : 'tamanho desconhecido';
              throw Exception(
                'Arquivo existe no Storage ($sizeInfo) mas não foi possível obter URL. '
                'Erro: $lastError. Tente novamente em alguns instantes.'
              );
            } catch (metadataError) {
              // Arquivo não existe - o upload pode ter falhado silenciosamente
              throw Exception(
                'Vídeo não encontrado no Storage após upload. '
                'O upload pode ter falhado ou o arquivo foi deletado. '
                'Erro original: $lastError. '
                'Verifique sua conexão e tente novamente.'
              );
            }
          }
          
          // Aguardar antes da próxima tentativa (delay progressivo)
          await Future.delayed(Duration(milliseconds: delayMs));
          delayMs = (delayMs * 1.2).round(); // Aumentar 20% a cada tentativa
        }
      }

      // Verificar se a URL foi obtida com sucesso
      if (videoUrl == null) {
        throw Exception('Não foi possível obter a URL do vídeo após o upload');
      }

      // Gerar thumbnail usando o mesmo videoId
      final thumbnailUrl = await generateThumbnail(finalPath, videoId);

      // Criar documento no Firestore
      final videoModel = VideoModel(
        id: videoId,
        ownerId: user.uid,
        title: title,
        description: description,
        game: game,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        createdAt: DateTime.now(),
      );

      final json = videoModel.toJson();
      json.remove('id');
      await _firestore
          .collection(FirestoreCollections.videos)
          .doc(videoId)
          .set(json);

      // Incrementar contador de vídeos do usuário
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .update({
        'videosCount': FieldValue.increment(1),
        'score': FieldValue.increment(AppConstants.pointsPerVideo),
      });

      return videoModel;
    } catch (e) {
      // Se o erro for no thumbnail e o vídeo já foi enviado, tenta continuar sem thumbnail
      if (e.toString().contains('thumbnail') && videoId != null && videoUrl != null) {
        try {
          // Tenta criar o vídeo sem thumbnail
          final videoModel = VideoModel(
            id: videoId,
            ownerId: user.uid,
            title: title,
            description: description,
            game: game,
            videoUrl: videoUrl,
            thumbnailUrl: null,
            createdAt: DateTime.now(),
          );

          final json = videoModel.toJson();
          json.remove('id');
          await _firestore
              .collection(FirestoreCollections.videos)
              .doc(videoId)
              .set(json);

          await _firestore
              .collection(FirestoreCollections.users)
              .doc(user.uid)
              .update({
            'videosCount': FieldValue.increment(1),
            'score': FieldValue.increment(AppConstants.pointsPerVideo),
          });

          return videoModel;
        } catch (e2) {
          throw Exception('Erro ao fazer upload do vídeo: $e2');
        }
      }
      throw Exception('Erro ao fazer upload do vídeo: $e');
    }
  }

  @override
  Future<void> deleteVideo(String videoId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final videoDoc = await _firestore
        .collection(FirestoreCollections.videos)
        .doc(videoId)
        .get();
    
    if (!videoDoc.exists) {
      throw Exception('Vídeo não encontrado');
    }
    
    final videoData = videoDoc.data()!;
    if (videoData['ownerId'] != user.uid) {
      throw Exception('Você não tem permissão para deletar este vídeo');
    }

    // Deletar do Storage
    final videoRef = _storage
        .ref()
        .child(AppConstants.videosStoragePath)
        .child('$videoId.mp4');
    await videoRef.delete();

    final thumbnailRef = _storage
        .ref()
        .child(AppConstants.thumbnailsStoragePath)
        .child('$videoId.jpg');
    await thumbnailRef.delete();

    // Deletar do Firestore
    await _firestore
        .collection(FirestoreCollections.videos)
        .doc(videoId)
        .delete();

    // Deletar likes
    final likesSnapshot = await _firestore
        .collection(FirestoreCollections.videos)
        .doc(videoId)
        .collection(FirestoreCollections.likes)
        .get();

    for (var doc in likesSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<String> generateThumbnail(String videoPath, String videoId) async {
    try {
      final thumbnail = await VideoCompress.getFileThumbnail(
        videoPath,
        quality: 50,
        position: 0,
      );

      // Verificar se o arquivo de thumbnail existe
      if (!await thumbnail.exists()) {
        throw Exception('Arquivo de thumbnail não encontrado');
      }

      final thumbnailRef = _storage
          .ref()
          .child(AppConstants.thumbnailsStoragePath)
          .child('$videoId.jpg');

      final uploadTask = thumbnailRef.putFile(thumbnail);
      
      // Aguardar o upload completar
      try {
        await uploadTask;
      } catch (uploadError) {
        throw Exception('Erro durante o upload do thumbnail: $uploadError');
      }
      
      // Aguardar um tempo para o Firebase Storage processar
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Obter a URL de download com retry
      int retries = 8;
      int delayMs = 1500;
      Exception? lastError;
      
      while (retries > 0) {
        try {
          final url = await thumbnailRef.getDownloadURL();
          if (url.isNotEmpty) {
            return url;
          }
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
          retries--;
          
          if (retries == 0) {
            // Verificar se o arquivo existe
            try {
              final metadata = await thumbnailRef.getMetadata();
              final sizeInfo = metadata.size != null ? '${metadata.size} bytes' : 'tamanho desconhecido';
              throw Exception('Thumbnail existe no Storage ($sizeInfo) mas não foi possível obter URL. Erro: $lastError');
            } catch (metadataError) {
              throw Exception('Thumbnail não encontrado no Storage. Erro: $lastError');
            }
          }
          
          await Future.delayed(Duration(milliseconds: delayMs));
          delayMs = (delayMs * 1.2).round();
        }
      }
      
      throw Exception('Erro ao obter URL do thumbnail após múltiplas tentativas');
    } catch (e) {
      throw Exception('Erro ao gerar thumbnail: $e');
    }
  }

  @override
  Future<void> likeVideo(String videoId, String userId) async {
    await _firestore.runTransaction((transaction) async {
      final videoRef = _firestore
          .collection(FirestoreCollections.videos)
          .doc(videoId);
      final likeRef = videoRef
          .collection(FirestoreCollections.likes)
          .doc(userId);

      final likeDoc = await transaction.get(likeRef);

      if (likeDoc.exists) {
        throw Exception('Você já curtiu este vídeo');
      }

      transaction.set(likeRef, {'userId': userId, 'createdAt': FieldValue.serverTimestamp()});
      transaction.update(videoRef, {
        'likesCount': FieldValue.increment(1),
      });

      // Incrementar pontos do usuário que curtiu
      final userRef = _firestore
          .collection(FirestoreCollections.users)
          .doc(userId);
      transaction.update(userRef, {
        'score': FieldValue.increment(AppConstants.pointsPerLike),
      });
    });
  }

  @override
  Future<void> unlikeVideo(String videoId, String userId) async {
    await _firestore.runTransaction((transaction) async {
      final videoRef = _firestore
          .collection(FirestoreCollections.videos)
          .doc(videoId);
      final likeRef = videoRef
          .collection(FirestoreCollections.likes)
          .doc(userId);

      final likeDoc = await transaction.get(likeRef);

      if (!likeDoc.exists) {
        throw Exception('Você não curtiu este vídeo');
      }

      transaction.delete(likeRef);
      transaction.update(videoRef, {
        'likesCount': FieldValue.increment(-1),
      });
    });
  }

  @override
  Future<bool> hasUserLikedVideo(String videoId, String userId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.videos)
        .doc(videoId)
        .collection(FirestoreCollections.likes)
        .doc(userId)
        .get();

    return doc.exists;
  }

  @override
  Future<void> incrementViews(String videoId) async {
    await _firestore
        .collection(FirestoreCollections.videos)
        .doc(videoId)
        .update({
      'viewsCount': FieldValue.increment(1),
    });
  }
}

