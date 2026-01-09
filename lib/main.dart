import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'pages/landing_page.dart';
import 'pages/auth_choice_page.dart';
import 'pages/account/login_page.dart';
import 'pages/account/signup_page.dart';
import 'pages/home_page.dart';
import 'pages/profile/notifications.dart';
import 'pages/profile/notification_provider.dart';
import 'widgets/connection_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);

  await Supabase.initialize(
    url: 'https://mftgbuarsclsbmuvrhes.supabase.co',
    anonKey: 'sb_publishable_GEI61TsfEO-CBg1SY-wZ0g_uGBcQ42p',
  );

  runApp(const MealFatigueApp());
}

class MealFatigueApp extends StatelessWidget {
  const MealFatigueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Meal Fatigue',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (_) => const LandingPage(),
          '/auth_choice': (_) => const AuthChoicePage(),
          '/login': (_) => const LoginPage(),
          '/signup': (_) => const SignupPage(),
          '/home': (_) => const HomePage(),
          '/notifications': (_) => const NotificationsPage(),
        },
        builder: (context, child) {
          return ConnectionWrapper(child: child!);
        },
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFCEBE8),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE7603E),
            primary: const Color(0xFFE7603E),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE7603E),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE7603E),
              side: const BorderSide(color: Color(0xFFE7603E), width: 2),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Color(0xFF333333)),
          ),
        ),
      ),
    );
  }
}
