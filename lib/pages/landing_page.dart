import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/auth_choice');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
            LogoWidget(big: true),
            SizedBox(height: 18),
            Text('Meal Fatigue',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
            SizedBox(height: 40),
            CircularProgressIndicator(color: Color(0xFFE7603E)),
          ]),
        ),
      ),
    );
  }
}
