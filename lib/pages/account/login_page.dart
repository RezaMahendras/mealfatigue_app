import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import Shared Preferences (as reference, though using DB helper)
import '../../database_helper.dart';
import '../../widgets/logo_widget.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Warna utama yang sama dengan Signup Page
  static const primaryOrange = Color(0xFFFF6B4A);

  bool obscure = true;
  bool _isLoading = false;
  bool _rememberMe = false; // Checkbox state

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedSession();
  }

  // Load data jika ada
  void _loadSavedSession() async {
    final session = await DatabaseHelper.instance.getSession();
    if (session != null) {
      setState(() {
        // Mengisi TextFields dengan data sesi yang tersimpan
        emailCtrl.text = session['email'];
        passCtrl.text = session['password'];
        _rememberMe = true;
      });
    }
  }

  void _handleLogin() async {
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      bool isAuthenticated = await DatabaseHelper.instance.loginUser(email, pass);

      if (isAuthenticated) {

        // --- PROSES SIMPAN DATA ---
        if (_rememberMe) {
          // Menyimpan kredensial ke DB Helper
          await DatabaseHelper.instance.saveSession(email, pass);
        } else {
          // Menghapus sesi jika 'Remember Me' tidak dicentang
          await DatabaseHelper.instance.clearSession();
        }
        // --------------------------

        if (!mounted) return;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Invalid Email or Password')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definisi dekorasi input agar sama dengan Signup Page
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Tombol Back)
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

                const SizedBox(height: 70),

                // Logo Diperbesar
                Center(
                  child: Transform.scale(
                    scale: 2.5,
                    child: const LogoWidget(big: false),
                  ),
                ),

                const SizedBox(height: 50),

                // Form Input Email
                TextField(
                    controller: emailCtrl,
                    decoration: inputDecoration.copyWith(hintText: 'Email')
                ),
                const SizedBox(height: 12),

                // Form Input Password
                TextField(
                  controller: passCtrl,
                  obscureText: obscure,
                  decoration: inputDecoration.copyWith(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      // Menggunakan warna abu-abu yang sama dengan Signup Page
                        icon: Icon(obscure ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                        onPressed: () => setState(() => obscure = !obscure)
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // CHECKBOX REMEMBER ME
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        // Menggunakan primaryOrange
                        activeColor: primaryOrange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) {
                          setState(() {
                            _rememberMe = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Menggunakan TextStyle yang lebih jelas (seperti di versi awal)
                    Text(
                      "Remember Me / Simpan Login",
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Tombol Login
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // Menggunakan primaryOrange
                            backgroundColor: primaryOrange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0 // Menghilangkan bayangan
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                            : const Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    )
                ),

                const SizedBox(height: 24),

                // Link Sign Up
                Center(
                    child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        child: Text(
                            'Don\'t have an account? Sign up',
                            // Menggunakan warna dan fontWeight yang sama dengan Signup Page
                            style: TextStyle(
                                color: primaryOrange.withOpacity(0.8),
                                fontWeight: FontWeight.w600
                            )
                        )
                    )
                )
              ]
          ),
        ),
      ),
    );
  }
}
