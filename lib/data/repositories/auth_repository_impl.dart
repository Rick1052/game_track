import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/user_model.dart';
import '../../core/constants/firestore_collections.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _getOrCreateUserData(credential.user!);
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
    String displayName,
  ) async {
    try {
      // Verificar se username já existe
      final usernameQuery = await _firestore
          .collection(FirestoreCollections.users)
          .where('username', isEqualTo: username)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        throw Exception('Nome de usuário já está em uso');
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      final userModel = UserModel(
        id: user.uid,
        email: email,
        username: username,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      final json = userModel.toJson();
      json.remove('id');
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .set(json);

      return userModel;
    } catch (e) {
      throw Exception('Erro ao criar conta: $e');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Login com Google cancelado');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return await _getOrCreateUserData(userCredential.user!);
    } catch (e) {
      throw Exception('Erro ao fazer login com Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Erro ao enviar email de recuperação: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await _getUserData(user.uid);
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    final json = user.toJson();
    json.remove('id');
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.id)
        .update(json);
  }

  Future<UserModel> _getOrCreateUserData(User user) async {
    final userData = await _getUserData(user.uid);
    if (userData != null) return userData;

    // Criar dados do usuário se não existir
    final username = user.displayName?.split(' ').first.toLowerCase() ?? 
                     user.email?.split('@').first ?? 'user${user.uid.substring(0, 6)}';
    
    final userModel = UserModel(
      id: user.uid,
      email: user.email ?? '',
      username: username,
      displayName: user.displayName ?? username,
      avatarUrl: user.photoURL,
      createdAt: DateTime.now(),
    );

    final json = userModel.toJson();
    json.remove('id');
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .set(json);

    return userModel;
  }

  Future<UserModel?> _getUserData(String userId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }
}

