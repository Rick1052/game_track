import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user_model.dart';
import '../../core/constants/firestore_collections.dart';
import '../../core/constants/app_constants.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<UserModel> getUserById(String userId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .get();

    if (!doc.exists) {
      throw Exception('Usuário não encontrado');
    }

    return UserModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
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
              ...doc.data()!,
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
                ...doc.data() as Map<String, dynamic>,
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
              ...doc.data()!,
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
              ...doc.data()!,
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
}

