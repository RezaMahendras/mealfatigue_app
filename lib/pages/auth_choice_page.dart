import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Definisi Warna Tema
    const Color themeColor = Colors.deepOrange;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36.0), // Padding asli Anda
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- LOGO ---
                Transform.scale(
                  scale: 2.5,
                  child: const LogoWidget(big: true),
                ),

                const SizedBox(height: 80),

                // --- TOMBOL 1: LOG IN (SOLID) ---
                // Bentuk tetap RoundedRectangleBorder(12) tapi warna penuh
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor, // Background OREN
                    foregroundColor: Colors.white, // Teks PUTIH
                    elevation: 3,
                    shadowColor: themeColor.withOpacity(0.4),
                    minimumSize: const Size(double.infinity, 50),
                    // KUNCI: Mempertahankan bentuk asli (Radius 12)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // --- TOMBOL 2: SIGN UP (OUTLINE) ---
                // Bentuk tetap RoundedRectangleBorder(12) tapi garis tepi
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white, // Background PUTIH
                    foregroundColor: themeColor, // Teks OREN
                    side: const BorderSide(color: themeColor, width: 2), // Garis tepi OREN
                    minimumSize: const Size(double.infinity, 50),
                    // KUNCI: Mempertahankan bentuk asli (Radius 12)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
