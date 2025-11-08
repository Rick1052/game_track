import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import 'repository_providers.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  return await ref.watch(authRepositoryProvider).getCurrentUserData();
});

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.getCurrentUserData();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signInWithEmailAndPassword(email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String username,
    String displayName,
  ) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email,
        password,
        username,
        displayName,
      );
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authRepository.sendPasswordResetEmail(email);
  }
}

