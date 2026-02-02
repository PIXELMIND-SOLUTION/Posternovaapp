

import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification_service.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    try {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      await getFCMToken();

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        print('FCM Token refreshed: $newToken');
      });

      // Foreground
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Background
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Tap notification
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }

  Future<String?> getFCMToken() async {
    _fcmToken = await _firebaseMessaging.getToken();
    print("FCM TOKEN: $_fcmToken");
    return _fcmToken;
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    print("Foreground Message: ${message.data}");

    // 🔥 This will show system notification even when app is open
    if (message.notification != null) {
      await LocalNotificationService.showNotification(
        title: message.notification!.title ?? "New Notification",
        body: message.notification!.body ?? "",
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Notification clicked: ${message.data}');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.messageId}');
}
