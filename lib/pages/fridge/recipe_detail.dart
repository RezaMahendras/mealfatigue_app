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
    return Scaffold(
      backgroundColor: Colors.white, // Latar Putih
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HEADER IMAGE & BACK BUTTON ---
              Stack(
                children: [
                  // Placeholder Gambar Makanan
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: cardSurface,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                      image: const DecorationImage(
                        // Gambar dummy
                        image: NetworkImage("https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?q=80&w=2000&auto=format&fit=crop"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Fallback jika gambar gagal
                    child: Center(child: Icon(Icons.restaurant_menu, size: 50, color: Colors.grey.withOpacity(0.5))),
                  ),
                  // Visual Tombol Play di Tengah Gambar
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  // Tombol Back
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
                    // --- 2. JUDUL & RATING ---
                    Text(
                      recipeData['title'],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: darkNavy), // Font Navy
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${recipeData['time']}  •  ${recipeData['difficulty']}", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, size: 16, color: primaryOrange), // Bintang Oranye
                        const SizedBox(width: 4),
                        Text(recipeData['rating'], style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- 3. NUTRISI INFO (Style Modern) ---
                    Row(
                      children: [
                        _buildNutritionBox("Kalori", recipeData['cal'], primaryOrange), // Teks Oranye
                        const SizedBox(width: 16),
                        _buildNutritionBox("Protein", recipeData['protein'], darkNavy), // Teks Navy
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- 4. BAHAN - BAHAN ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200), // Border tipis
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bahan - bahan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
                          const SizedBox(height: 12),
                          // Generate list bahan
                          ...List.generate(recipeData['ingredients'].length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Icon(Icons.circle, size: 8, color: primaryOrange.withOpacity(0.6)), // Bullet Oranye
                                  const SizedBox(width: 10),
                                  Text(recipeData['ingredients'][index], style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A), fontWeight: FontWeight.w500)),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- 5. CARA MEMASAK (Preview) ---
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
                          // Generate list langkah
                          ...List.generate(recipeData['steps'].length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nomer Langkah dengan lingkaran kecil
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

                    // --- 6. TOMBOL AKSI ---

                    // Tombol Tonton Video (Secondary Style: Putih Border Oranye)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoTutorialPage(
                                videoAssetPath: recipeData['videoPath'] ?? 'assets/videos/tutorial_brokoli.mp4',
                                recipeTitle: recipeData['title'],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: primaryOrange) // Border Oranye
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

                    // Tombol Mulai Memasak (Primary Style: Oranye Solid)
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

  // Widget Helper untuk Kotak Nutrisi
  Widget _buildNutritionBox(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cardSurface, // Abu-abu muda
          borderRadius: BorderRadius.circular(16),
          // Tidak ada border agar terlihat clean
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
