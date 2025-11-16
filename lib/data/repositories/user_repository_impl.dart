import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user_model.dart';
import '../../core/constants/firestore_collections.dart';
import '../../core/constants/app_constants.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  UserRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _storage = storage,
        _auth = auth;

  @override
  Future<UserModel> getUserById(String userId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .get();

    if (!doc.exists) {
      throw Exception('Usuário não encontrado');
    }

    final data = doc.data();
    if (data == null) {
      throw Exception('Documento sem dados: ${doc.id}');
    }
    return UserModel.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  @override
  Future<List<UserModel>> searchUsers(String query, {int limit = 20}) async {
    if (query.isEmpty) return [];

    final snapshot = await _firestore
        .collection(FirestoreCollections.users)
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Stream<List<UserModel>> searchUsersStream(String query) {
    if (query.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection(FirestoreCollections.users)
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    });
  }

  @override
  Future<void> followUser(String userId, String targetUserId) async {
    if (userId == targetUserId) {
      throw Exception('Você não pode seguir a si mesmo');
    }

    await _firestore.runTransaction((transaction) async {
      final userRef = _firestore
          .collection(FirestoreCollections.users)
          .doc(userId);
      final targetUserRef = _firestore
          .collection(FirestoreCollections.users)
          .doc(targetUserId);

      final followRef = userRef
          .collection(FirestoreCollections.following)
          .doc(targetUserId);
      final followerRef = targetUserRef
          .collection(FirestoreCollections.followers)
          .doc(userId);

      final followDoc = await transaction.get(followRef);

      if (followDoc.exists) {
        throw Exception('Você já está seguindo este usuário');
      }

      transaction.set(followRef, {
        'userId': targetUserId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      transaction.set(followerRef, {
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      transaction.update(userRef, {
        'followingCount': FieldValue.increment(1),
      });
      transaction.update(targetUserRef, {
        'followersCount': FieldValue.increment(1),
        'score': FieldValue.increment(AppConstants.pointsPerFollower),
      });
    });
  }

  @override
  Future<void> unfollowUser(String userId, String targetUserId) async {
    await _firestore.runTransaction((transaction) async {
      final userRef = _firestore
          .collection(FirestoreCollections.users)
          .doc(userId);
      final targetUserRef = _firestore
          .collection(FirestoreCollections.users)
          .doc(targetUserId);

      final followRef = userRef
          .collection(FirestoreCollections.following)
          .doc(targetUserId);
      final followerRef = targetUserRef
          .collection(FirestoreCollections.followers)
          .doc(userId);

      final followDoc = await transaction.get(followRef);

      if (!followDoc.exists) {
        throw Exception('Você não está seguindo este usuário');
      }

      transaction.delete(followRef);
      transaction.delete(followerRef);

      transaction.update(userRef, {
        'followingCount': FieldValue.increment(-1),
      });
      transaction.update(targetUserRef, {
        'followersCount': FieldValue.increment(-1),
      });
    });
  }

  @override
  Future<bool> isFollowing(String userId, String targetUserId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .collection(FirestoreCollections.following)
        .doc(targetUserId)
        .get();

    return doc.exists;
  }

  @override
  Future<List<UserModel>> getFollowers(String userId) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .collection(FirestoreCollections.followers)
        .get();

    final followerIds = snapshot.docs
        .map((doc) => doc.data()['userId'] as String)
        .toList();

    if (followerIds.isEmpty) return [];

    final usersSnapshot = await _firestore
        .collection(FirestoreCollections.users)
        .where(FieldPath.documentId, whereIn: followerIds)
        .get();

    return usersSnapshot.docs
        .map((doc) => UserModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<List<UserModel>> getFollowing(String userId) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .collection(FirestoreCollections.following)
        .get();

    final followingIds = snapshot.docs
        .map((doc) => doc.data()['userId'] as String)
        .toList();

    if (followingIds.isEmpty) return [];

    final usersSnapshot = await _firestore
        .collection(FirestoreCollections.users)
        .where(FieldPath.documentId, whereIn: followingIds)
        .get();

    return usersSnapshot.docs
        .map((doc) => UserModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }

  @override
  Future<void> updateUserScore(String userId, int points) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .update({
      'score': FieldValue.increment(points),
    });
  }

  @override
  Future<void> incrementUserVideosCount(String userId) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .update({
      'videosCount': FieldValue.increment(1),
    });
  }

  @override
  Future<String> uploadImage(String filePath, String userId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');
    
    // Verificar se o usuário está tentando fazer upload da própria imagem
    if (user.uid != userId) {
      throw Exception('Você só pode fazer upload da sua própria imagem');
    }

    final imageFile = File(filePath);
    
    // Verificar se o arquivo existe
    if (!await imageFile.exists()) {
      throw Exception('Arquivo de imagem não encontrado: $filePath');
    }

    // Verificar tamanho do arquivo (max 5MB para imagens)
    final fileSize = await imageFile.length();
    const maxSize = 5 * 1024 * 1024; // 5MB
    if (fileSize > maxSize) {
      throw Exception('Imagem muito grande. Tamanho máximo: 5MB');
    }

    try {
      // Determinar extensão do arquivo
      final extension = filePath.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        throw Exception('Formato de imagem não suportado. Use JPG, PNG ou WebP');
      }

      final imageFileName = '$userId.$extension';

      // Upload da imagem
      final imageRef = _storage
          .ref()
          .child(AppConstants.avatarsStoragePath)
          .child(imageFileName);

      final uploadTask = imageRef.putFile(imageFile);
      
      // Aguardar o upload completar
      await uploadTask;
      
      // Obter a URL de download com retry em caso de erro
      // O Firebase Storage pode levar um tempo para disponibilizar o arquivo
      int retries = 5;
      int delayMs = 1000;
      String? imageUrl;
      
      while (retries > 0) {
        try {
          await Future.delayed(Duration(milliseconds: delayMs));
          imageUrl = await imageRef.getDownloadURL();
          break;
        } catch (e) {
          retries--;
          if (retries == 0) {
            throw Exception('Erro ao obter URL da imagem após upload: $e');
          }
          // Aumentar o tempo de espera a cada tentativa
          delayMs += 500;
        }
      }

      // Verificar se a URL foi obtida com sucesso
      if (imageUrl == null) {
        throw Exception('Não foi possível obter a URL da imagem após o upload');
      }

      // Atualizar o avatarUrl do usuário no Firestore
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
        'avatarUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return imageUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }
}

