import 'package:flutter/material.dart';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class CookingModePage extends StatefulWidget {
  final Map<String, dynamic> recipeData;

  const CookingModePage({Key? key, required this.recipeData}) : super(key: key);

  @override
  State<CookingModePage> createState() => _CookingModePageState();
}

class _CookingModePageState extends State<CookingModePage> {
  // Melacak langkah mana yang sedang aktif
  int _currentStepIndex = 0;

  void _completeStep(int index) {
    // Hanya bisa klik langkah yang sedang aktif (urutan)
    if (index == _currentStepIndex) {
      setState(() {
        _currentStepIndex++; // Maju ke langkah berikutnya
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah semua langkah sudah selesai
    bool isAllFinished = _currentStepIndex >= (widget.recipeData['steps'] as List).length;

    return Scaffold(
      backgroundColor: Colors.white, // Latar Putih
      appBar: AppBar(
        title: Text(widget.recipeData['title'], style: const TextStyle(color: darkNavy, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // ==========================================================
        // PERUBAHAN UTAMA DI SINI
        automaticallyImplyLeading: false, // Matikan tombol kembali bawaan
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            // Menggunakan darkNavy sebagai warna ikon
            child: const Icon(Icons.arrow_back, color: darkNavy, size: 20),
          ),
        ),
        // ==========================================================
        iconTheme: const IconThemeData(color: darkNavy),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER INFO (Waktu & Rating) ---
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${widget.recipeData['time']}  •  ${widget.recipeData['difficulty']}", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                const Icon(Icons.star, size: 16, color: primaryOrange),
                const SizedBox(width: 4),
                Text(widget.recipeData['rating'], style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy)),
              ],
            ),
            const SizedBox(height: 20),

            // --- NUTRISI INFO (Style Modern) ---
            Row(
              children: [
                _buildNutritionBox("Kalori", widget.recipeData['cal'], primaryOrange),
                const SizedBox(width: 16),
                _buildNutritionBox("Protein", widget.recipeData['protein'], darkNavy),
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
                  border: Border.all(color: Colors.grey.shade200), // Border tipis
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Bahan - bahan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
                  const SizedBox(height: 12),
                  ...List.generate(widget.recipeData['ingredients'].length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: primaryOrange.withOpacity(0.6)), // Bullet Oranye
                          const SizedBox(width: 10),
                          Text(widget.recipeData['ingredients'][index], style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- CARA MEMASAK (INTERAKTIF) ---
            const Text("Cara Memasak", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
            const SizedBox(height: 12),

            // Loop Langkah-Langkah
            ...List.generate(widget.recipeData['steps'].length, (index) {
              bool isCompleted = index < _currentStepIndex;
              bool isActive = index == _currentStepIndex;

              return GestureDetector(
                onTap: () => _completeStep(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 12),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // Jika selesai: Oranye Pudar
                    // Jika belum: Putih
                    color: isCompleted ? primaryOrange.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isActive
                        ? Border.all(color: primaryOrange, width: 2) // Highlight border jika giliran aktif
                        : Border.all(color: isCompleted ? Colors.transparent : Colors.grey.shade200),
                    boxShadow: isActive
                        ? [BoxShadow(color: primaryOrange.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))]
                        : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${index + 1}. ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            // Jika aktif/selesai: Navy, Jika belum: Grey
                            color: (isActive || isCompleted) ? darkNavy : Colors.grey
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.recipeData['steps'][index],
                          style: TextStyle(
                              fontSize: 15,
                              color: isCompleted ? darkNavy : const Color(0xFF4A4A4A),
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal
                          ),
                        ),
                      ),
                      // Icon Check jika selesai
                      if (isCompleted)
                        const Icon(Icons.check_circle, color: primaryOrange),
                      // Icon Arrow jika sedang aktif
                      if (isActive)
                        const Icon(Icons.arrow_circle_right_outlined, color: primaryOrange)
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // --- TOMBOL SELESAI (Muncul jika semua langkah beres) ---
            if (isAllFinished)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Tutup Cooking Mode dan Detail Resep
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: primaryOrange.withOpacity(0.4)
                  ),
                  child: const Text('SELESAI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper Nutrisi (Sama dengan RecipeDetail)
  Widget _buildNutritionBox(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cardSurface, // Abu-abu muda
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
