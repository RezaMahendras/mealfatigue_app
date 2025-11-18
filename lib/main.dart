import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/auth_choice_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';

void main() => runApp(MealFatigueApp());

class MealFatigueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Fatigue',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const LandingPage(),
        '/auth_choice': (_) => const AuthChoicePage(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFCEBE8),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE7603E),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xFF333333))),
      ),
    );
  }
}
