import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/FCM/fcm_service.dart';
import 'services/FCM/local_notification_service.dart';
import 'services/language/restart_lan_service.dart';

import 'providers/PosterProvider/category_poster_provider.dart';
import 'providers/PosterProvider/getall_poster_provider.dart';
import 'providers/PosterProvider/poster_provider.dart';
import 'providers/auth/login_provider.dart';
import 'providers/auth/otp_provider.dart';
import 'providers/auth/register_provider.dart';
import 'providers/chat/chat_provider.dart';
import 'providers/customer/customer_provider.dart';
import 'providers/festivals/date_time_provider.dart';
import 'providers/festivals/festival_provider.dart';
import 'providers/invoices/invoice_provider.dart';
import 'providers/logo/logo_provider.dart';
import 'providers/plans/get_all_plan_provider.dart';
import 'providers/plans/my_plan_provider.dart';
import 'providers/plans/plan_provider.dart';
import 'providers/redeem/redeem_provider.dart';
import 'providers/reels/reels_provider.dart';
import 'providers/story/report_provider.dart';
import 'providers/story/story_provider.dart';

import 'views/NavBar/navbar_screen.dart';
import 'views/splash.dart';
import 'widgets/language_widget.dart';

/// 🔴 REQUIRED for iOS background notifications
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('📦 Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  try {
    /// 1️⃣ Initialize Firebase FIRST
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// 2️⃣ Register background handler BEFORE runApp
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    /// 3️⃣ Initialize local notifications
    await LocalNotificationService.init();

    /// 4️⃣ Initialize FCM
    await FCMService().initialize();

    print('✅ Firebase & FCM initialized successfully');
  } catch (e) {
    print('❌ Error initializing Firebase/FCM: $e');
  }

  runApp(
    AppRestartWrapper(
      key: AppRestartService.key,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CanvaPosterProvider()),
        ChangeNotifierProvider(create: (_) => DateTimeProvider()),
        ChangeNotifierProvider(create: (_) => FestivalProvider()),
        ChangeNotifierProvider(create: (_) => PosterProvider()),
        ChangeNotifierProvider(create: (_) => CategoryPosterProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => ReportStoryProvider()),
        ChangeNotifierProvider(create: (_) => CreateCustomerProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => SmsProvider()),
        ChangeNotifierProvider(create: (_) => LogoProvider()),
        ChangeNotifierProvider(create: (_) => ProductInvoiceProvider()),
        ChangeNotifierProvider(create: (_) => GetAllPlanProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
        ChangeNotifierProvider(create: (_) => MyPlanProvider()),
        ChangeNotifierProvider(create: (_) => RedeemProvider()),
        ChangeNotifierProvider(create: (_) => ReelProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'EditEzy',
            debugShowCheckedModeBanner: false,

            locale: languageProvider.locale,

            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('te'),
              Locale('ta'),
            ],

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.deepPurple,
              textTheme:
                  ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.white,
              textTheme:
                  ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
            ),

            home: AppRestartService.skipSplash
                ? const MainNavigationScreen()
                : SplashScreen(),
          );
        },
      ),
    );
  }
}