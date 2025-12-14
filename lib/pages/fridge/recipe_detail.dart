import 'package:flutter/material.dart';
import 'video_tutorial_page.dart';
import 'cooking_mode_page.dart';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  const RecipeDetailPage({Key? key, required this.recipeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // 1. LOGIKA PENENTUAN GAMBAR (AUTO DETECT JUDUL)
    // ============================================================
    String imagePath = recipeData['image'] ?? '';
    String titleLower = recipeData['title'].toString().toLowerCase();

    // Jika data gambar kosong, kita isi manual berdasarkan Judul Resep
    if (imagePath.isEmpty) {
      if (titleLower.contains('brokoli')) {
        imagePath = "https://d1vbn70lmn1nqe.cloudfront.net/prod/wp-content/uploads/2023/12/28084722/Ini-Cara-Membuat-dan-Resep-Tumis-Brokoli-yang-Mudah-dibuat-di-rumah.jpg.webp";
      } else if (titleLower.contains('avocado') || titleLower.contains('alpukat')) {
        imagePath = "https://cdn.yummy.co.id/content-images/images/20220324/XIejvq5IOtSW9JIQe2KZ0tP0tUIKxASR-31363438313130393936d41d8cd98f00b204e9800998ecf8427e.jpg?x-oss-process=image/resize,w_600,h_600,m_fill,image/format,webp";
      }
    }

    // Tentukan Tipe Image Provider (Network / Asset)
    ImageProvider imageProvider;
    if (imagePath.startsWith('http')) {
      imageProvider = NetworkImage(imagePath);
    } else if (imagePath.isNotEmpty) {
      imageProvider = AssetImage(imagePath);
    } else {
      imageProvider = const NetworkImage("https://via.placeholder.com/400x300?text=No+Image");
    }

    // ============================================================
    // 2. FUNGSI NAVIGASI KE VIDEO (Reusable)
    // ============================================================
    void _playVideo() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoTutorialPage(
            videoAssetPath: recipeData['videoPath'] ?? 'assets/videos/tutorial_brokoli.mp4',
            recipeTitle: recipeData['title'],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER IMAGE & BACK BUTTON ---
              Stack(
                children: [
                  // A. GAMBAR BISA DIKLIK (GestureDetector)
                  GestureDetector(
                    onTap: _playVideo, // [BARU] Klik gambar -> Putar Video
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: cardSurface,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // B. VISUAL TOMBOL PLAY DI TENGAH
                  // Menggunakan IgnorePointer agar jika user klik pas di ikon play,
                  // sentuhannya tembus ke GestureDetector gambar di belakangnya.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                  ),

                  // C. TOMBOL BACK
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                        ),
                        child: const Icon(Icons.arrow_back, color: darkNavy, size: 20),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- JUDUL & RATING ---
                    Text(
                      recipeData['title'],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: darkNavy),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${recipeData['time']}  •  ${recipeData['difficulty']}", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, size: 16, color: primaryOrange),
                        const SizedBox(width: 4),
                        Text(recipeData['rating'], style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- NUTRISI INFO ---
                    Row(
                      children: [
                        _buildNutritionBox("Kalori", recipeData['cal'], primaryOrange),
                        const SizedBox(width: 16),
                        _buildNutritionBox("Protein", recipeData['protein'], darkNavy),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- BAHAN - BAHAN ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bahan - bahan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
                          const SizedBox(height: 12),
                          if (recipeData['ingredients'] != null)
                            ...List.generate(recipeData['ingredients'].length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.circle, size: 8, color: primaryOrange.withOpacity(0.6)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(recipeData['ingredients'][index], style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A), fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- CARA MEMASAK ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Cara Memasak", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
                          const SizedBox(height: 12),
                          if (recipeData['steps'] != null)
                            ...List.generate(recipeData['steps'].length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 24, height: 24,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(8)),
                                      child: Text("${index + 1}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkNavy)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(recipeData['steps'][index], style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A), height: 1.5)),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- TOMBOL AKSI ---

                    // 1. Tombol Tonton Video
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _playVideo, // [UPDATED] Menggunakan fungsi yang sama dengan gambar
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: primaryOrange)
                            ),
                            elevation: 0
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.play_circle_outline, color: primaryOrange),
                            SizedBox(width: 8),
                            Text('Tonton Video Tutorial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 2. Tombol Mulai Memasak
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CookingModePage(recipeData: recipeData),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            shadowColor: primaryOrange.withOpacity(0.4)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.soup_kitchen, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Mulai Memasak!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionBox(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
          ],
        ),
      ),
    );
  }
}
