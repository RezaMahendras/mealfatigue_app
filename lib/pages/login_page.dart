import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscure = true;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

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
                  Text('Log In', style: TextStyle(fontSize: 16)),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            const Center(child: LogoWidget(big: false)),
            const SizedBox(height: 24),
            TextField(controller: emailCtrl, decoration: const InputDecoration(hintText: 'Email', filled: true)),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: 'Password',
                filled: true,
                suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => obscure = !obscure)),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {
              final e = emailCtrl.text;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logging in: $e')));
            }, child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Log In')))),
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
            Center(child: TextButton(onPressed: () => Navigator.pushNamed(context, '/signup'), child: const Text('Don\'t have an account? Sign up')))
          ]),
        ),
      ),
    );
  }

  Widget _socialBox(String asset) {
    return Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]), padding: const EdgeInsets.all(8), child: Image.asset(asset, fit: BoxFit.contain, errorBuilder: (_,__,___)=> const Icon(Icons.image_not_supported)));
  }
}
