

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:posternova/firebase_options.dart';
// import 'local_notification_service.dart';

// class FCMService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   static final FCMService _instance = FCMService._internal();
//   factory FCMService() => _instance;
//   FCMService._internal();

//   String? _fcmToken;
//   String? get fcmToken => _fcmToken;

//   Future<void> initialize() async {
//     try {
//       await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//       await getFCMToken();

//       _firebaseMessaging.onTokenRefresh.listen((newToken) {
//         _fcmToken = newToken;
//         print('FCM Token refreshed: $newToken');
//       });

//       // Foreground
//       FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//       // Background
//       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//       // Tap notification
//       FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

//     } catch (e) {
//       print('Error initializing FCM: $e');
//     }
//   }

//   Future<String?> getFCMToken() async {
//     _fcmToken = await _firebaseMessaging.getToken();
//     print("FCM TOKEN: $_fcmToken");
//     return _fcmToken;
//   }

//   void _handleForegroundMessage(RemoteMessage message) async {
//     print("Foreground Message: ${message.data}");

//     // 🔥 This will show system notification even when app is open
//     if (message.notification != null) {
//       await LocalNotificationService.showNotification(
//         title: message.notification!.title ?? "New Notification",
//         body: message.notification!.body ?? "",
//       );
//     }
//   }

//   void _handleMessageOpenedApp(RemoteMessage message) {
//     print('Notification clicked: ${message.data}');
//   }
// }
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   print('Background message: ${message.messageId}');
// }












import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:posternova/firebase_options.dart';
import 'package:posternova/services/FCM/local_notification_service.dart';

class FCMService {
  // Singleton
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  late FirebaseMessaging _messaging;
  bool _initialized = false;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// 🔐 Initialize FCM (CALL ONLY FROM main.dart)
  Future<void> initialize() async {
    if (_initialized) return;

    _messaging = FirebaseMessaging.instance;

    // Request permission (iOS mandatory)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get initial token
    _fcmToken = await _messaging.getToken();
    print('✅ FCM TOKEN: $_fcmToken');

    // Token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      print('🔁 FCM Token refreshed: $newToken');
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    _initialized = true;
  }

  /// ✅ SAFE token getter (for Providers)
  Future<String?> getFCMTokenSafe() async {
    if (!_initialized) {
      print('⚠️ FCMService not initialized yet');
      return null;
    }

    _fcmToken ??= await _messaging.getToken();
    return _fcmToken;
  }

  /// 🔔 Foreground notification handler
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📩 Foreground message: ${message.data}');

    if (message.notification != null) {
      await LocalNotificationService.showNotification(
        title: message.notification!.title ?? 'New Notification',
        body: message.notification!.body ?? '',
      );
    }
  }

  /// 📲 Notification tap handler
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('👉 Notification clicked: ${message.data}');
  }
}

/// 🔴 REQUIRED for iOS background notifications
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('📦 Background message: ${message.messageId}');
}
