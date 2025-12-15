import 'package:flutter/material.dart';
import '../../database_helper.dart';
import '../../widgets/logo_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // State untuk visibilitas password
  bool obscurePass = true;
  bool obscureConfirm = true;
  bool _isLoading = false;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  // Warna utama yang sama dengan Login Page
  static const primaryOrange = Color(0xFFFF6B4A);

  void _handleSignup() async {
    // Mengambil text dan menghapus spasi di awal/akhir
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();
    String confirm = confirmCtrl.text.trim();

    // Helper untuk menampilkan SnackBar
    void showSnackbar(String message, {Color color = Colors.black}) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: color, content: Text(message)));
    }

    // 1. Validasi Input Kosong
    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      showSnackbar('Please fill all fields');
      return;
    }

    // 2. Validasi Email harus @gmail.com
    if (!email.toLowerCase().endsWith('@gmail.com')) {
      showSnackbar('Registration is restricted to @gmail.com only');
      return;
    }

    // 3. Validasi Panjang Password (MINIMAL 8 KARAKTER)
    if (pass.length < 8) {
      showSnackbar('Password must be at least 8 characters long');
      return;
    }

    // 4. Validasi Password Mengandung Angka (BARU DITAMBAHKAN)
    // Menggunakan Regular Expression: r'.*[0-9].*' berarti string harus mengandung setidaknya satu angka (0-9).
    if (!pass.contains(RegExp(r'[0-9]'))) {
      showSnackbar('Password must contain at least one number');
      return;
    }

    // 5. Validasi Password Match
    if (pass != confirm) {
      showSnackbar('Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Menambah sedikit delay untuk feedback UI
      await Future.delayed(const Duration(milliseconds: 500));

      await DatabaseHelper.instance.registerUser(email, pass);

      if (!mounted) return;
      showSnackbar('Registration Success! Please Login.', color: Colors.green);

      // Navigasi ke halaman login setelah berhasil
      Navigator.pushReplacementNamed(context, '/login');

    } catch (e) {
      print("SIGNUP ERROR: $e");
      String message = 'Registration Failed';
      if (e.toString().contains("UNIQUE constraint failed")) {
        message = 'Email already registered!';
      }
      if (!mounted) return;
      showSnackbar(message, color: Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ... (dispose, _buildPasswordSuffixIcon, dan build tetap sama)

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  // Widget untuk tombol mata di input password
  Widget _buildPasswordSuffixIcon(bool isObscure, VoidCallback onPressed) {
    return IconButton(
      // Menggunakan warna abu-abu yang sama dengan Login Page
      icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definisi dekorasi input agar sama dengan Login Page
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
                      Text('Sign Up', style: TextStyle(fontSize: 16)),
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
                    // Mengubah keyboard type agar tombol @ muncul lebih mudah
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration.copyWith(hintText: 'Email (@gmail.com)')
                ),
                const SizedBox(height: 12),

                // Form Input Password
                TextField(
                    controller: passCtrl,
                    obscureText: obscurePass,
                    decoration: inputDecoration.copyWith(
                        hintText: 'Password (Min 8 characters, with a number)',
                        suffixIcon: _buildPasswordSuffixIcon(
                            obscurePass,
                                () => setState(() => obscurePass = !obscurePass)
                        )
                    )
                ),
                const SizedBox(height: 12),

                // Form Input Confirm Password
                TextField(
                    controller: confirmCtrl,
                    obscureText: obscureConfirm,
                    decoration: inputDecoration.copyWith(
                        hintText: 'Confirm Password',
                        suffixIcon: _buildPasswordSuffixIcon(
                            obscureConfirm,
                                () => setState(() => obscureConfirm = !obscureConfirm)
                        )
                    )
                ),
                const SizedBox(height: 24),

                // Tombol Sign Up
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // Menggunakan warna orange yang sama
                            backgroundColor: primaryOrange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0
                        ),
                        onPressed: _isLoading ? null : _handleSignup,
                        child: _isLoading
                            ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                            : const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    )
                ),

                const SizedBox(height: 24),

                // Link Login
                Center(
                    child: TextButton(
                        onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/login'),
                        child: Text(
                            'Already have an account? Log in',
                            // Menggunakan warna orange yang sama dan fontWeight yang sama
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
