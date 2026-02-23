import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';
import 'local_notification_service.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  late FirebaseMessaging _messaging;
  bool _initialized = false;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// 🔐 Initialize FCM
  Future<void> initialize() async {
    if (_initialized) return;

    _messaging = FirebaseMessaging.instance;

    /// 🔔 Request permission (IMPORTANT for iOS)
    if (Platform.isIOS) {
      NotificationSettings settings =
          await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      if (settings.authorizationStatus ==
          AuthorizationStatus.denied) {
        print('❌ User denied notification permission');
      }
    }

    /// 🔑 Get FCM Token
    _fcmToken = await _messaging.getToken();
    print('✅ FCM TOKEN: $_fcmToken');

    /// 🔄 Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      print('🔁 FCM Token refreshed: $newToken');
    });

    /// 📩 Foreground message
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    /// 📲 Notification tap
    FirebaseMessaging.onMessageOpenedApp.listen(
      _handleMessageOpenedApp,
    );

    _initialized = true;
  }

  /// ✅ Safe Token Getter
  Future<String?> getFCMTokenSafe() async {
    if (!_initialized) {
      print('⚠️ FCMService not initialized yet');
      return null;
    }

    _fcmToken ??= await _messaging.getToken();
    return _fcmToken;
  }

  /// 🔔 Foreground notification handler
  Future<void> _handleForegroundMessage(
      RemoteMessage message) async {
    print('📩 Foreground message: ${message.data}');

    if (message.notification != null) {
      await LocalNotificationService.showNotification(
        title: message.notification!.title ?? 'New Notification',
        body: message.notification!.body ?? '',
      );
    }
  }

  /// 📲 Notification clicked
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('👉 Notification clicked: ${message.data}');
  }
}