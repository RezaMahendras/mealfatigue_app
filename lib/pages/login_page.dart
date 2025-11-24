import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../widgets/logo_widget.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscure = true;
  bool _isLoading = false;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  void _handleLogin() async {
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      bool isAuthenticated = await DatabaseHelper.instance.loginUser(email, pass);

      if (isAuthenticated) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Invalid Email or Password')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), // Padding asli
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 10),
                child: Row(children: const [
                  Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF333333)), // Warna Asli
                  SizedBox(width: 6),
                  Text('Log In', style: TextStyle(fontSize: 16)),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            const Center(child: LogoWidget(big: false)),
            const SizedBox(height: 24),

            TextField(controller: emailCtrl, decoration: inputDecoration.copyWith(hintText: 'Email')),
            const SizedBox(height: 12),

            TextField(
              controller: passCtrl,
              obscureText: obscure,
              decoration: inputDecoration.copyWith(
                hintText: 'Password',
                suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => obscure = !obscure)),
              ),
            ),
            const SizedBox(height: 18),

            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Log In')
                )
            ),

            const SizedBox(height: 12),
            const Center(child: Text('Or', style: TextStyle(color: Color(0xFF9A9A9A)))), // Warna Asli
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
