import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../widgets/logo_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool obscure = true;
  bool _isLoading = false;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  void _handleSignup() async {
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();
    String confirm = confirmCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Delay simulasi sebentar
      await Future.delayed(const Duration(milliseconds: 500));

      await DatabaseHelper.instance.registerUser(email, pass);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text('Registration Success! Please Login.'))
      );
      Navigator.pushReplacementNamed(context, '/login');

    } catch (e) {
      print("SIGNUP ERROR: $e");
      String message = 'Registration Failed';
      if (e.toString().contains("UNIQUE constraint failed")) {
        message = 'Email already registered!';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Style input dikembalikan ke default 'filled: true' namun tetap rapi
    final inputDecoration = InputDecoration(
      filled: true,
      // Saya hapus fillColor custom, jadi ikut default tema
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Tetap rounded biar elegan
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), // Padding asli Anda
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 10),
                    child: Row(children: const [
                      Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF333333)), // Warna Asli
                      SizedBox(width: 6),
                      Text('Sign Up', style: TextStyle(fontSize: 16)),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(child: LogoWidget(big: false)),
                const SizedBox(height: 18),

                TextField(controller: emailCtrl, decoration: inputDecoration.copyWith(hintText: 'Email')),
                const SizedBox(height: 12),

                TextField(
                    controller: passCtrl,
                    obscureText: obscure,
                    decoration: inputDecoration.copyWith(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => obscure = !obscure)
                        )
                    )
                ),
                const SizedBox(height: 12),

                TextField(
                    controller: confirmCtrl,
                    obscureText: obscure,
                    decoration: inputDecoration.copyWith(hintText: 'Confirm Password')
                ),
                const SizedBox(height: 16),

                // Tombol Sign Up
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // Warna ikut default tema (biasanya biru)
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Tetap rounded
                        padding: const EdgeInsets.symmetric(vertical: 12), // Padding asli + sedikit tinggi
                      ),
                      onPressed: _isLoading ? null : _handleSignup,
                      child: _isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Sign Up'),
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

                Center(
                    child: TextButton(
                        onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Already have account? Log in')
                    )
                )
              ]
          ),
        ),
      ),
    );
  }

  Widget _socialBox(String asset) {
    // Style box asli (shadow black12)
    return Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset(asset, fit: BoxFit.contain, errorBuilder: (_,__,___)=> const Icon(Icons.image_not_supported))
    );
  }
}
