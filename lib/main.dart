// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:posternova/firebase_options.dart';
// import 'package:posternova/providers/PosterProvider/category_poster_provider.dart';
// import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
// import 'package:posternova/providers/PosterProvider/poster_provider.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:posternova/providers/auth/otp_provider.dart';
// import 'package:posternova/providers/auth/register_provider.dart';
// import 'package:posternova/providers/customer/customer_provider.dart';
// import 'package:posternova/providers/festivals/date_time_provider.dart';
// import 'package:posternova/providers/festivals/festival_provider.dart';
// import 'package:posternova/providers/invoices/invoice_provider.dart';
// import 'package:posternova/providers/logo/logo_provider.dart';
// import 'package:posternova/providers/plans/get_all_plan_provider.dart';
// import 'package:posternova/providers/plans/my_plan_provider.dart';
// import 'package:posternova/providers/plans/plan_provider.dart';
// import 'package:posternova/providers/redeem/redeem_provider.dart';
// import 'package:posternova/providers/reels/reels_provider.dart';
// import 'package:posternova/providers/story/report_provider.dart';
// import 'package:posternova/providers/story/story_provider.dart';
// import 'package:posternova/services/FCM/fcm_service.dart';
// import 'package:posternova/services/FCM/local_notification_service.dart';
// import 'package:posternova/views/splash.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");

//   try {
//     // Initialize Firebase

//     await LocalNotificationService.init();
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     print('✅ Firebase initialized successfully');

//     // Initialize FCM Service
//     await FCMService().initialize();
//     print('✅ FCM Service initialized successfully');
//   } catch (e) {
//     print('❌ Error initializing Firebase/FCM: $e');
//     // App will continue to run even if Firebase initialization fails
//   }

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//         statusBarBrightness: Brightness.light,
//       ),
//     );

//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CanvaPosterProvider()),
//         ChangeNotifierProvider(create: (_) => DateTimeProvider()),
//         ChangeNotifierProvider(create: (_) => FestivalProvider()),
//         ChangeNotifierProvider(create: (_) => PosterProvider()),
//         ChangeNotifierProvider(create: (_) => CategoryPosterProvider()),
//         ChangeNotifierProvider(create: (_) => StoryProvider()),
//         ChangeNotifierProvider(create: (_) => ReportStoryProvider()),
//         ChangeNotifierProvider(create: (_) => CreateCustomerProvider()),
//         ChangeNotifierProvider(create: (_) => LanguageProvider()),
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => SignupProvider()),
//         ChangeNotifierProvider(create: (_) => SmsProvider()),
//         ChangeNotifierProvider(create: (_) => LogoProvider()),
//         ChangeNotifierProvider(create: (_) => ProductInvoiceProvider()),
//         ChangeNotifierProvider(create: (_) => GetAllPlanProvider()),
//         ChangeNotifierProvider(create: (_) => PlanProvider()),
//         ChangeNotifierProvider(create: (_) => MyPlanProvider()),
//         ChangeNotifierProvider(create: (_) => RedeemProvider()),
//         ChangeNotifierProvider(create: (_) => ReelProvider()),
//       ],
//       child: MaterialApp(
//         title: 'PosterNova',
//         theme: ThemeData(
//           brightness: Brightness.light,
//           scaffoldBackgroundColor: Colors.white,
//           primarySwatch: Colors.deepPurple,
//           textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: Colors.deepPurple,
//             brightness: Brightness.light,
//           ),
//         ),
//         darkTheme: ThemeData(
//           brightness: Brightness.dark,
//           scaffoldBackgroundColor: Colors.white,
//           textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: Colors.deepPurple,
//             brightness: Brightness.dark,
//           ),
//         ),
//         home: SplashScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }




import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:posternova/firebase_options.dart';
import 'package:posternova/providers/PosterProvider/category_poster_provider.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/providers/PosterProvider/poster_provider.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/providers/auth/otp_provider.dart';
import 'package:posternova/providers/auth/register_provider.dart';
import 'package:posternova/providers/chat/chat_provider.dart';
import 'package:posternova/providers/customer/customer_provider.dart';
import 'package:posternova/providers/festivals/date_time_provider.dart';
import 'package:posternova/providers/festivals/festival_provider.dart';
import 'package:posternova/providers/invoices/invoice_provider.dart';
import 'package:posternova/providers/logo/logo_provider.dart';
import 'package:posternova/providers/plans/get_all_plan_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/providers/plans/plan_provider.dart';
import 'package:posternova/providers/redeem/redeem_provider.dart';
import 'package:posternova/providers/reels/reels_provider.dart';
import 'package:posternova/providers/story/report_provider.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:posternova/services/FCM/fcm_service.dart';
import 'package:posternova/services/FCM/local_notification_service.dart';
import 'package:posternova/services/language/restart_lan_service.dart';
import 'package:posternova/views/NavBar/navbar_screen.dart';
import 'package:posternova/views/splash.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  try {
    // Initialize Firebase
    await LocalNotificationService.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');

    // Initialize FCM Service

    await FCMService().initialize();
    print('✅ FCM Service initialized successfully');
  } catch (e) {
    print('❌ Error initializing Firebase/FCM: $e');
    // App will continue to run even if Firebase initialization fails
  }

  runApp(
    AppRestartWrapper(
      key: AppRestartService.key,
      child: MyApp(), 
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
            // Set the locale from the provider
            locale: languageProvider.locale,
            // Define supported locales
            supportedLocales: const [
              Locale('en'), // English22
              Locale('hi'), // Hindi
              Locale('te'), // Telugu
              Locale('ta'), // Tamil
            ],
            // Add localization delegates to support Material widgets in all languages
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.deepPurple,
              textTheme: ThemeData.light().textTheme.apply(
                fontFamily: 'Poppins',
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.white,
              textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'Poppins',
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
            ),

            // home: SplashScreen(),
            home: AppRestartService.skipSplash
                ? const MainNavigationScreen()
                : SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
