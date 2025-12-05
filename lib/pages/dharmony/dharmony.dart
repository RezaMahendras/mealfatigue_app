import 'package:flutter/material.dart';
import 'couple_profile_page.dart'; // Navigasi ke Profil
import 'weekend_menu_page.dart';   // Navigasi ke Menu Weekend

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class DHarmonyPage extends StatelessWidget {
  const DHarmonyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar Putih sesuai request
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20), // Jarak atas standar

              // --- 1. HEADER (PERBAIKAN) ---
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.favorite, size: 36, color: primaryOrange), // Icon Oranye
                        SizedBox(width: 12), // Jarak antar elemen
                        Text(
                          'Diet Harmony',
                          style: TextStyle(
                            fontSize: 28, // Ukuran 28
                            fontWeight: FontWeight.w800, // Tebal
                            color: darkNavy, // Warna Navy
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Meal planning untuk hubungan sehat',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- 2. CARD 1: HARMONY SCORE ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Couple Harmony Score",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "85%",
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: darkNavy),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.people_outline, size: 24, color: darkNavy),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Stats Row
                    Row(
                      children: [
                        _buildStatBox("4", "Week Streak", Icons.local_fire_department, Colors.red),
                        const SizedBox(width: 12),
                        _buildStatBox("23", "Meal Together", Icons.restaurant_menu, darkNavy),
                        const SizedBox(width: 12),
                        _buildStatBox("68%", "Less Conflict", Icons.trending_up, Colors.green),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Button Lihat Profil
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigasi ke Halaman Profil Couple
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CoupleProfilePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          shadowColor: primaryOrange.withOpacity(0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.people, size: 18),
                            SizedBox(width: 8),
                            Text("Lihat Profil Couple", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- 3. CARD 2: WEEKEND PLANNING ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_awesome, size: 20, color: primaryOrange),
                        SizedBox(width: 8),
                        Text(
                          "Weekend Planning",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkNavy),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Jumat sore ini, kami sudah siapkan 3 menu weekend yang cocok untuk kalian berdua.",
                      style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigasi ke Halaman Weekend Menu
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WeekendMenuPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: primaryOrange) // Border Oranye
                          ),
                          elevation: 0,
                        ),
                        child: const Text("Lihat Menu Weekend", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- 4. CARD 3: RECENT ACTIVITY ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.chat_bubble_outline, size: 20, color: darkNavy),
                        SizedBox(width: 8),
                        Text(
                          "Recent Activity",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkNavy),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildActivityItem("Both agreed on \"Vegan Tacos\"", "Yesterday · 5★ from both", isStarred: true),
                    const SizedBox(height: 16),
                    _buildActivityItem("Unlocked \"4 Week Harmony Streak\"", "3 days ago"),
                    const SizedBox(height: 16),
                    _buildActivityItem("Person B loved \"Mushroom Risoto\"", "1 week ago"),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade200), // Border tipis
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    );
  }

  Widget _buildStatBox(String value, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: cardSurface, // Abu-abu muda
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: darkNavy)),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, {bool isStarred = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bullet Point Oranye
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 8, color: primaryOrange.withOpacity(0.5)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: darkNavy)),
                  ),
                  if (isStarred) const Icon(Icons.star, size: 16, color: Colors.amber)
                ],
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
