import 'package:flutter/material.dart';

// --- Warna (Konsisten) ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color backgroundGrey = Color(0xFFF8F9FA); // Warna latar belakang abu muda

class LegalContentPage extends StatelessWidget {
  final String title;
  final String content;

  const LegalContentPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey, // Background sedikit abu-abu
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: darkNavy, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true, // Scrollbar selalu terlihat saat digulir
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // --- BADGE TANGGAL UPDATE ---
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 16, color: primaryOrange.withOpacity(0.8)),
                    const SizedBox(width: 8),
                    Text(
                      "Last updated: December 14, 2025",
                      style: TextStyle(
                        color: primaryOrange.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // --- KARTU KONTEN ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  content,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                    height: 1.8, // Spasi baris lebih lebar agar mudah dibaca
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.justify, // Rata kanan-kiri
                ),
              ),

              // Footer space agar tidak mentok bawah
              const SizedBox(height: 30),

              Text(
                "© 2025 Meal Fatigue App",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
