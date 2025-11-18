import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool obscure = true;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 10),
                child: Row(children: const [
                  Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF333333)),
                  SizedBox(width: 6),
                  Text('Sign Up', style: TextStyle(fontSize: 16)),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            const Center(child: LogoWidget(big: false)),
            const SizedBox(height: 18),
            TextField(controller: emailCtrl, decoration: const InputDecoration(hintText: 'Email', filled: true)),
            const SizedBox(height: 12),
            TextField(controller: passCtrl, obscureText: obscure, decoration: InputDecoration(hintText: 'Password', filled: true, suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => obscure = !obscure)))),
            const SizedBox(height: 12),
            TextField(controller: confirmCtrl, obscureText: obscure, decoration: const InputDecoration(hintText: 'Confirm Password', filled: true)),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign up (stub)'))), child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Sign Up')))),
            const SizedBox(height: 12),
            const Center(child: Text('Or', style: TextStyle(color: Color(0xFF9A9A9A)))),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _socialBox('assets/ic_apple.png'),
              const SizedBox(width: 12),
              _socialBox('assets/ic_google.png'),
              const SizedBox(width: 12),
              _socialBox('assets/ic_facebook.png'),
            ]),
            const SizedBox(height: 18),
            Center(child: TextButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: const Text('Already have account? Log in')))
          ]),
        ),
      ),
    );
  }

  Widget _socialBox(String asset) {
    return Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]), padding: const EdgeInsets.all(8), child: Image.asset(asset, fit: BoxFit.contain, errorBuilder: (_,__,___)=> const Icon(Icons.image_not_supported)));
  }
}
