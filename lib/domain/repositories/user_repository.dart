import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUserById(String userId);
  Future<List<UserModel>> searchUsers(String query, {int limit = 20});
  Stream<List<UserModel>> searchUsersStream(String query);
  Future<void> followUser(String userId, String targetUserId);
  Future<void> unfollowUser(String userId, String targetUserId);
  Future<bool> isFollowing(String userId, String targetUserId);
  Future<List<UserModel>> getFollowers(String userId);
  Future<List<UserModel>> getFollowing(String userId);
  Future<void> updateUserScore(String userId, int points);
  Future<void> incrementUserVideosCount(String userId);
}

