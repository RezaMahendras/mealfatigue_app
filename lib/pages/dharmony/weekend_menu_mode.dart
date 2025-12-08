import 'package:flutter/material.dart';
import 'weekend_cooking_mode.dart';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA); // Abu-abu kebiruan muda
const Color textGrey = Color(0xFF64748B);

class WeekendMenuDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String price;
  final String matchPercent;

  const WeekendMenuDetailPage({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
    required this.price,
    required this.matchPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar Putih Bersih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Menu Detail", style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 16)),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(Icons.arrow_back, color: darkNavy, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER INFO
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Text("Recommended", style: TextStyle(color: primaryOrange, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: darkNavy, height: 1.2),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: textGrey, height: 1.6),
            ),
            const SizedBox(height: 16),

            // META INFO (Row Simple)
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: textGrey),
                const SizedBox(width: 6),
                Text(time, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: darkNavy)),
                const SizedBox(width: 16),
                const Icon(Icons.payments_outlined, size: 16, color: textGrey),
                const SizedBox(width: 6),
                Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: darkNavy)),
              ],
            ),
            const SizedBox(height: 30),

            // 2. COMPATIBILITY CARD (Premium Look)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Compatibility Score", style: TextStyle(fontSize: 12, color: textGrey, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(matchPercent, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: primaryOrange)),
                      const SizedBox(height: 4),
                      const Text(
                        "Perfect Match for both dietary needs",
                        style: TextStyle(fontSize: 12, color: darkNavy),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.favorite, size: 28, color: primaryOrange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. PERSON PREFERENCES (Clean Split)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildPersonBox("Person A", "High protein (telur opsional)", "4.5", darkNavy),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPersonBox("Person B", "Full plant based (no telur)", "4.8", primaryOrange),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. NUTRITION FACTS (Minimalist)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardSurface, // Latar Abu Muda
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nutrition Facts", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: darkNavy)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNutrientItem("380", "Kcal"),
                      _buildVerticalDivider(),
                      _buildNutrientItem("18g", "Protein"),
                      _buildVerticalDivider(),
                      _buildNutrientItem("42g", "Carbs"),
                      _buildVerticalDivider(),
                      _buildNutrientItem("14g", "Fat"),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. INGREDIENTS & ACTION
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kiri: Ingredients List
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkNavy)),
                      const SizedBox(height: 12),
                      _buildIngredientItem("Quinoa"),
                      _buildIngredientItem("Avocado"),
                      _buildIngredientItem("Sweet Potato"),
                      _buildIngredientItem("Chickpeas"),
                      _buildIngredientItem("Kale"),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Kanan: Action Card
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Agreement Mode", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: darkNavy)),
                        const SizedBox(height: 4),
                        const Text("Waiting for partner...", style: TextStyle(fontSize: 11, color: textGrey)),
                        const SizedBox(height: 16),

                        // Tombol Love It
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryOrange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("I Love it!", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Tombol Try Again
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textGrey,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("Suggest Other", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // 6. BOTTOM BUTTON (Start Cooking)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeekendCookingModePage(
                        recipeTitle: title, // Mengirim judul resep (cth: Mushroom Stroganoff)
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkNavy, // Navy untuk tombol utama bawah agar beda
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: darkNavy.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.restaurant, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text('Start Cooking Together', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildPersonBox(String name, String desc, String rating, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 10, backgroundColor: accentColor.withOpacity(0.1), child: Icon(Icons.person, size: 12, color: accentColor)),
              const SizedBox(width: 6),
              Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: darkNavy)),
              const Spacer(),
              Icon(Icons.star, size: 12, color: primaryOrange),
              Text(rating, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: darkNavy)),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 11, color: textGrey, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildNutrientItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: darkNavy)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: textGrey, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 20, width: 1, color: Colors.grey.shade300);
  }

  Widget _buildIngredientItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: primaryOrange),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: darkNavy, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
