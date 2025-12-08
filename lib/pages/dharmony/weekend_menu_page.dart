import 'package:flutter/material.dart';
import 'weekend_menu_detail.dart'; // Import Halaman Detail

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA); // Abu-abu kebiruan muda
const Color textGrey = Color(0xFF64748B); // Slate Grey

class WeekendMenuPage extends StatelessWidget {
  const WeekendMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar Putih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
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
            // --- HEADER TITLE ---
            const Text(
              "Weekend Menu Options",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: darkNavy,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Pick up together",
              style: TextStyle(fontSize: 14, color: textGrey),
            ),
            const SizedBox(height: 30),

            // --- CARD 1: BUDDHA BOWL (DIBUNGKUS GESTURE DETECTOR) ---
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WeekendMenuDetailPage(
                      title: "Buddha Bowl + Egg Option",
                      description: "Bowl dengan quinoa, chickpeas, avocado, sayuran panggang.",
                      time: "30 min",
                      price: "Rp 45.000",
                      matchPercent: "92%",
                    ),
                  ),
                );
              },
              child: _buildPremiumCard(
                title: "Buddha Bowl + Egg Option",
                matchPercent: "92%",
                description: "Bowl dengan quinoa, chickpeas, avocado, sayuran panggang. Telur bisa ditambah opsional.",
                tags: ["Win-win", "Nutrient Dense"],
                personA: "High protein (telur)",
                personB: "Plant-based (no telur)",
                time: "30 min",
                price: "Rp 45.000",
              ),
            ),

            const SizedBox(height: 20),

            // --- CARD 2: MUSHROOM STROGANOFF ---
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WeekendMenuDetailPage(
                      title: "Mushroom Stroganoff",
                      description: "Creamy mushroom sauce dengan coconut cream.",
                      time: "35 min",
                      price: "Rp 55.000",
                      matchPercent: "87%",
                    ),
                  ),
                );
              },
              child: _buildPremiumCard(
                title: "Mushroom Stroganoff",
                matchPercent: "87%",
                description: "Creamy mushroom sauce dengan coconut cream, cauliflower rice.",
                tags: ["Comfort Food", "Low Sugar"],
                personA: "Diabetes friendly",
                personB: "Vegan friendly",
                time: "35 min",
                price: "Rp 55.000",
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER: KARTU MENU PREMIUM ---
  Widget _buildPremiumCard({
    required String title,
    required String matchPercent,
    required String description,
    required List<String> tags,
    required String personA,
    required String personB,
    required String time,
    required String price,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        // Shadow Premium: Halus tapi menyebar
        boxShadow: [
          BoxShadow(color: darkNavy.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          // --- BAGIAN ATAS: Header, Tags, Desc ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row Judul & Match
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: darkNavy, height: 1.2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Match Badge (Solid Orange - High Contrast)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: primaryOrange,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: primaryOrange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                      ),
                      child: Text(
                        "$matchPercent Match",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(description, style: const TextStyle(fontSize: 13, color: textGrey, height: 1.5)),

                const SizedBox(height: 16),

                // Tags (Clean Chips)
                Wrap(
                  spacing: 8,
                  children: tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: cardSurface, // Abu Muda
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(tag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: darkNavy)),
                  )).toList(),
                ),
              ],
            ),
          ),

          // --- DIVIDER ---
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),

          // --- BAGIAN BAWAH: Perbandingan Person A vs B ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Person A (Navy Accent)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.person, size: 16, color: darkNavy),
                          SizedBox(width: 6),
                          Text("Person A", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkNavy)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(personA, style: const TextStyle(fontSize: 12, color: textGrey)),
                    ],
                  ),
                ),

                // Vertical Line
                Container(width: 1, height: 30, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 16)),

                // Person B (Orange Accent)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.person_outline, size: 16, color: primaryOrange),
                          SizedBox(width: 6),
                          Text("Person B", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryOrange)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(personB, style: const TextStyle(fontSize: 12, color: textGrey)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- FOOTER: Price & Time ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9).withOpacity(0.5), // Abu sangat pudar untuk footer
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: textGrey),
                    const SizedBox(width: 6),
                    Text(time, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: darkNavy)),
                  ],
                ),
                Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: primaryOrange)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
