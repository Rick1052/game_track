import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import 'repository_providers.dart';
import 'firebase_providers.dart';

final searchUsersProvider = StreamProvider.family<List<UserModel>, String>((ref, query) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.searchUsersStream(query);
});

final userProvider = FutureProvider.family<UserModel, String>((ref, userId) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getUserById(userId);
});

final isFollowingProvider = FutureProvider.family<bool, FollowParams>((ref, params) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.isFollowing(params.userId, params.targetUserId);
});

class FollowParams {
  final String userId;
  final String targetUserId;

  FollowParams({
    required this.userId,
    required this.targetUserId,
  });
}

final followControllerProvider = StateNotifierProvider.family<FollowController, AsyncValue<void>, String>((ref, targetUserId) {
  // Solução temporária: usar Firebase Auth diretamente até os arquivos Freezed serem gerados
  final auth = ref.watch(firebaseAuthProvider);
  final currentUserId = auth.currentUser?.uid ?? '';
  
  return FollowController(
    ref.watch(userRepositoryProvider),
    currentUserId,
    targetUserId,
  );
});

class FollowController extends StateNotifier<AsyncValue<void>> {
  final UserRepository _repository;
  final String _userId;
  final String _targetUserId;

  FollowController(this._repository, this._userId, this._targetUserId)
      : super(const AsyncValue.data(null));

  Future<void> follow() async {
    state = const AsyncValue.loading();
    try {
      await _repository.followUser(_userId, _targetUserId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> unfollow() async {
    state = const AsyncValue.loading();
    try {
      await _repository.unfollowUser(_userId, _targetUserId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

