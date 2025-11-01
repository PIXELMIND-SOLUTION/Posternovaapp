import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/providers/PosterProvider/category_poster_provider.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/providers/PosterProvider/poster_provider.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/providers/auth/otp_provider.dart';
import 'package:posternova/providers/auth/register_provider.dart';
import 'package:posternova/providers/customer/customer_provider.dart';
import 'package:posternova/providers/festivals/date_time_provider.dart';
import 'package:posternova/providers/festivals/festival_provider.dart';
import 'package:posternova/providers/invoices/invoice_provider.dart';
import 'package:posternova/providers/logo/logo_provider.dart';
import 'package:posternova/providers/plans/get_all_plan_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/providers/plans/plan_provider.dart';
import 'package:posternova/providers/redeem/redeem_provider.dart';
import 'package:posternova/providers/story/report_provider.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:posternova/views/splash.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
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
        ChangeNotifierProvider(create: (_) => CanvaPosterProvider() ),
        ChangeNotifierProvider(create: (_) => DateTimeProvider()),
        ChangeNotifierProvider(create: (_) => FestivalProvider()),
        ChangeNotifierProvider(create: (_) => PosterProvider()),
        ChangeNotifierProvider(create: (_) => CategoryPosterProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => ReportStoryProvider()),
        ChangeNotifierProvider(create: (_) => CreateCustomerProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => SmsProvider()),
        ChangeNotifierProvider(create: (_) => LogoProvider()),
        ChangeNotifierProvider(create: (_)=>ProductInvoiceProvider()),
        ChangeNotifierProvider(create: (_) => GetAllPlanProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
        ChangeNotifierProvider(create: (_) => MyPlanProvider()),
        ChangeNotifierProvider(create: (_) => RedeemProvider()),


      ],
      child: MaterialApp(
        title: 'PosterNova',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.deepPurple,
          textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.white,
          textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
