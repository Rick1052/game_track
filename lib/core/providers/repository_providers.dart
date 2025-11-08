import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/voucher_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/video_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/voucher_repository.dart';
import 'firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepositoryImpl(
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

final voucherRepositoryProvider = Provider<VoucherRepository>((ref) {
  return VoucherRepositoryImpl(
    firestore: ref.watch(firebaseFirestoreProvider),
    functions: ref.watch(firebaseFunctionsProvider),
  );
});

