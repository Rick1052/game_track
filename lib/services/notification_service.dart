import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firestore_collections.dart';

class NotificationService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  NotificationService({
    required FirebaseMessaging messaging,
    required FirebaseFirestore firestore,
  })  : _messaging = messaging,
        _firestore = firestore;

  /// Solicita permissão para notificações e obtém o token FCM
  Future<String?> getToken() async {
    try {
      // Solicitar permissão (iOS)
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Obter token FCM
        final token = await _messaging.getToken();
        return token;
      }
      return null;
    } catch (e) {
      print('Erro ao obter token FCM: $e');
      return null;
    }
  }

  /// Salva o token FCM do usuário no Firestore
  Future<void> saveUserToken(String userId, String token) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao salvar token FCM: $e');
    }
  }

  /// Remove o token FCM quando o usuário faz logout
  Future<void> removeUserToken(String userId) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
        'fcmToken': FieldValue.delete(),
        'fcmTokenUpdatedAt': FieldValue.delete(),
      });
    } catch (e) {
      print('Erro ao remover token FCM: $e');
    }
  }

  /// Configura handlers para notificações
  void setupNotificationHandlers() {
    // Notificação recebida quando o app está em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notificação recebida (foreground): ${message.notification?.title}');
      // Aqui você pode mostrar uma notificação local ou atualizar a UI
    });

    // Quando o usuário toca na notificação e o app é aberto
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App aberto via notificação: ${message.notification?.title}');
      // Navegar para a tela apropriada baseada nos dados da notificação
    });

    // Verificar se o app foi aberto via notificação (quando estava fechado)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App aberto via notificação (fechado): ${message.notification?.title}');
      }
    });
  }
}

