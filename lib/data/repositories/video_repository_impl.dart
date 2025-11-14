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

      final videoId = _uuid.v4();
      final videoFile = File(finalPath);
      final videoFileName = '$videoId.mp4';

      // Upload do vídeo
      final videoRef = _storage
          .ref()
          .child(AppConstants.videosStoragePath)
          .child(videoFileName);

      await videoRef.putFile(videoFile);
      final videoUrl = await videoRef.getDownloadURL();

      // Gerar thumbnail
      final thumbnailUrl = await generateThumbnail(finalPath);

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
  Future<String> generateThumbnail(String videoPath) async {
    try {
      final thumbnail = await VideoCompress.getFileThumbnail(
        videoPath,
        quality: 50,
        position: 0,
      );

      final videoId = _uuid.v4();
      final thumbnailRef = _storage
          .ref()
          .child(AppConstants.thumbnailsStoragePath)
          .child('$videoId.jpg');

      await thumbnailRef.putFile(thumbnail);
      return await thumbnailRef.getDownloadURL();
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

