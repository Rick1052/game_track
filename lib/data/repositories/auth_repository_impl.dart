import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/user_model.dart';
import '../../core/constants/firestore_collections.dart';
import '../../services/notification_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final NotificationService? _notificationService;

  AuthRepositoryImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
    NotificationService? notificationService,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _notificationService = notificationService;

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
      final userModel = await _getOrCreateUserData(credential.user!);
      
      // Salvar token FCM e enviar notificação de boas-vindas
      await _handleLoginSuccess(credential.user!.uid);
      
      return userModel;
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
      final userModel = await _getOrCreateUserData(userCredential.user!);
      
      // Salvar token FCM e enviar notificação de boas-vindas
      await _handleLoginSuccess(userCredential.user!.uid);
      
      return userModel;
    } catch (e) {
      String errorMessage = 'Erro ao fazer login com Google';
      final errorString = e.toString();
      
      if (errorString.contains('sign_in_failed') || errorString.contains('Api10')) {
        errorMessage = 'Erro de configuração do Google Sign-In. Verifique se o SHA-1 foi adicionado no Firebase Console e se o OAuth está configurado. Veja CONFIGURAR_GOOGLE_SIGNIN.md para mais detalhes.';
      } else if (errorString.contains('cancelado')) {
        errorMessage = 'Login com Google cancelado';
      } else if (errorString.contains('network')) {
        errorMessage = 'Erro de conexão. Verifique sua internet';
      }
      
      throw Exception('$errorMessage: $e');
    }
  }

  @override
  Future<void> signOut() async {
    final userId = _auth.currentUser?.uid;
    
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
    
    // Remover token FCM ao fazer logout
    if (userId != null && _notificationService != null) {
      await _notificationService!.removeUserToken(userId);
    }
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
    final data = doc.data()!;
    data['id'] = userId; // Adiciona o ID ao JSON
    return UserModel.fromJson(data);
  }

  /// Lida com o sucesso do login: salva token FCM e envia notificação
  Future<void> _handleLoginSuccess(String userId) async {
    if (_notificationService == null) return;
    
    try {
      // Obter token FCM
      final token = await _notificationService!.getToken();
      
      if (token != null) {
        // Salvar token no Firestore
        await _notificationService!.saveUserToken(userId, token);
        
        // Chamar Cloud Function para enviar notificação de boas-vindas
        // A função será chamada automaticamente quando o token for salvo
        // ou podemos chamar diretamente aqui
        await _sendWelcomeNotification(userId);
      }
    } catch (e) {
      // Não falhar o login se houver erro na notificação
      print('Erro ao configurar notificações: $e');
    }
  }

  /// Envia notificação de boas-vindas via Cloud Function
  Future<void> _sendWelcomeNotification(String userId) async {
    try {
      // Buscar dados do usuário para personalizar a mensagem
      final userData = await _getUserData(userId);
      if (userData == null) return;

      // Chamar Cloud Function para enviar notificação
      // Nota: A Cloud Function será criada para enviar a notificação
      // Por enquanto, apenas salvamos o token. A função será chamada automaticamente
      // quando detectar que o token foi atualizado após login
    } catch (e) {
      print('Erro ao enviar notificação de boas-vindas: $e');
    }
  }
}

