import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const LogoWidget(big: true),
              const SizedBox(height: 18),
              const Text('Meal Fatigue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 36),
              ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: const Text('Log in')),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/signup'), child: const Text('Sign Up')),
            ]),
          ),
        ),
      ),
    );
  }
}
