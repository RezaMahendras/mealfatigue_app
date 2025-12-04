import 'package:flutter/material.dart';
// --- SESUAIKAN IMPORT INI DENGAN STRUKTUR FOLDER ANDA ---
import 'profile/profile_page.dart';
import 'koslife/kos_life.dart';
import 'fridge/fridge_chef.dart';
import 'dharmony/dharmony.dart';

// --- DEFINISI WARNA TEMA ---
const Color darkNavy = Color(0xFF1E293B);
const Color primaryOrange = Color(0xFFFF6B4A);
const Color premiumPurple = Color(0xFF8B5CF6);
const Color deepIndigo = Color(0xFF4338CA);

// =========================================================
// 1. HOME PAGE (PARENT NAVIGATION)
// =========================================================
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardTab(),
    const KosLifePage(),
    const FridgeChefPage(),
    const DHarmonyPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, -2)
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: primaryOrange,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home' // Label wajib ada, tidak boleh null
            ),
            BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'KosLife'),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Chef'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Love'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// 2. DASHBOARD TAB (UPDATED: SALAD, JUS, & BUAH)
// =========================================================
class DashboardTab extends StatefulWidget {
  const DashboardTab({Key? key}) : super(key: key);

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  String getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hi, Mealer!!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.local_fire_department, color: primaryOrange, size: 18),
                          SizedBox(width: 4),
                          Text('10 days streak!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      final homeState = context.findAncestorStateOfType<_HomePageState>();
                      homeState?._onItemTapped(4); // Navigasi ke Profile
                    },
                    child: Container(
                      width: 45, height: 45,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))
                          ]
                      ),
                      child: const Icon(Icons.person, color: Color(0xFF2D2D2D)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // --- CALENDAR STRIP ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(7, (index) {
                    DateTime date = startOfWeek.add(Duration(days: index));
                    bool isToday = (date.day == now.day && date.month == now.month && date.year == now.year);
                    return _buildDateItem(dayName: getDayName(date.weekday), dayDate: date.day.toString(), isSelected: isToday, isActive: true);
                  }),
                ),
              ),
              const SizedBox(height: 30),

              // --- INFO CARDS (ARTIKEL PREMIUM) ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // KARTU 1: SALAD SAYUR (HIJAU)
                    _buildInfoCard(
                        title: "Salad Sayur Sehat",
                        subtitle: "Resep segar & manfaat diet...",
                        color: Colors.green.withOpacity(0.1),
                        icon: Icons.eco,
                        iconColor: Colors.green[700]!,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailPage(
                          title: "Salad Sayur Sehat",
                          category: "Healthy Food",
                          readTime: "5 min read",
                          icon: Icons.eco,
                          accentColor: Colors.green,
                          contentWidgets: [
                            const Text(
                              "Salad sayur adalah pilihan terbaik untuk kamu yang ingin hidup lebih sehat atau menurunkan berat badan. Makanan ini kaya akan serat, vitamin, dan mineral.",
                              style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF475569)),
                            ),
                            const SizedBox(height: 24),

                            _buildSectionTitle("Manfaat Utama"),
                            _buildBulletPoint("Melancarkan Pencernaan", "Kandungan serat tinggi membantu usus bekerja lebih baik."),
                            _buildBulletPoint("Turun Berat Badan", "Rendah kalori namun mengenyangkan, cocok untuk defisit kalori."),
                            _buildBulletPoint("Kulit Glowing", "Sayuran segar mengandung antioksidan yang melawan penuaan dini."),
                            const SizedBox(height: 24),

                            _buildSectionTitle("Resep Simple (5 Menit)"),
                            _buildIngredientItem("Selada Romaine / Iceberg", "Potong kasar"),
                            _buildIngredientItem("5 Buah Tomat Cherry", "Belah dua"),
                            _buildIngredientItem("1/2 Timun Jepang", "Iris tipis"),
                            _buildIngredientItem("3 sdm Jagung Manis", "Rebus sebentar"),
                            _buildIngredientItem("Telur Rebus", "Untuk protein tambahan"),
                            const SizedBox(height: 24),

                            _buildSectionTitle("Dressing Sehat"),
                            const Text(
                              "Campurkan 1 sdm Olive Oil, 1 sdt perasan jeruk lemon, sejumput garam, dan lada hitam. Aduk rata lalu siram ke atas sayuran.",
                              style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF475569)),
                            ),
                            const SizedBox(height: 32),

                            // Kotak Tips
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                border: const Border(left: BorderSide(color: Colors.orange, width: 4)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("PRO TIP", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                                  SizedBox(height: 8),
                                  Text(
                                    "Hindari dressing kemasan (Thousand Island/Mayo) jika sedang diet ketat karena tinggi lemak dan gula. Gunakan Olive Oil sebagai gantinya.",
                                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )))
                    ),
                    const SizedBox(width: 16),

                    // KARTU 2: JUS DETOX (ORANGE)
                    _buildInfoCard(
                        title: "Jus Detox Alami",
                        subtitle: "Resep booster imun & energi...",
                        color: Colors.orange.withOpacity(0.1),
                        icon: Icons.local_drink,
                        iconColor: Colors.orange[800]!,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailPage(
                          title: "Jus Detox Alami",
                          category: "Healthy Drink",
                          readTime: "3 min read",
                          icon: Icons.local_drink,
                          accentColor: Colors.orange,
                          contentWidgets: [
                            const Text(
                              "Merasa lelah atau kulit kusam? Jus buah dan sayur murni bisa menjadi cara cepat untuk menyerap nutrisi dan mendetoks tubuh dari racun.",
                              style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF475569)),
                            ),
                            const SizedBox(height: 24),

                            _buildSectionTitle("Resep: ABC Miracle"),
                            const Text(
                              "Kombinasi klasik Apple, Beetroot, dan Carrot yang terkenal ampuh meningkatkan energi.",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            _buildIngredientItem("1 Buah Apel Merah", "Manis alami"),
                            _buildIngredientItem("1 Buah Bit (Beetroot)", "Kupas kulit"),
                            _buildIngredientItem("2 Batang Wortel", "Cuci bersih"),
                            _buildIngredientItem("1 Ruas Jahe", "Opsional, untuk hangat"),
                            const SizedBox(height: 24),

                            _buildSectionTitle("Manfaat Rutin"),
                            _buildBulletPoint("Booster Imun", "Kaya Vitamin A dan C dari wortel dan apel."),
                            _buildBulletPoint("Detoks Hati", "Buah bit membantu membersihkan organ hati."),
                            _buildBulletPoint("Mata Sehat", "Kandungan beta-carotene tinggi."),
                            const SizedBox(height: 32),

                            // Kotak Tips
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                border: const Border(left: BorderSide(color: Colors.blue, width: 4)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("BEST TIME", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                  SizedBox(height: 8),
                                  Text(
                                    "Minumlah jus ini di pagi hari saat perut kosong (30 menit sebelum sarapan) untuk penyerapan nutrisi yang maksimal.",
                                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )))
                    ),
                    const SizedBox(width: 16),

                    // KARTU 3: SUPER FRUITS (MERAH/PINK) - [BARU DITAMBAHKAN]
                    _buildInfoCard(
                        title: "Super Fruits Guide",
                        subtitle: "Pilihan buah rendah gula & serat...",
                        color: Colors.redAccent.withOpacity(0.1),
                        icon: Icons.apple,
                        iconColor: Colors.redAccent,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailPage(
                          title: "Super Fruits Guide",
                          category: "Nutrition Fact",
                          readTime: "4 min read",
                          icon: Icons.apple,
                          accentColor: Colors.redAccent,
                          contentWidgets: [
                            const Text(
                              "Tidak semua buah diciptakan sama. Saat diet, pilihlah buah dengan indeks glikemik rendah namun tinggi serat untuk menjaga rasa kenyang lebih lama.",
                              style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF475569)),
                            ),
                            const SizedBox(height: 24),

                            _buildSectionTitle("Top 3 Buah Diet"),
                            _buildIngredientItem("Apel (dengan kulit)", "Kaya serat pectin"),
                            _buildIngredientItem("Pepaya", "Melancarkan pencernaan"),
                            _buildIngredientItem("Berries", "Rendah gula & antioksidan"),
                            _buildIngredientItem("Alpukat", "Lemak sehat (mengenyangkan)"),
                            const SizedBox(height: 24),

                            _buildSectionTitle("Cara Konsumsi"),
                            _buildBulletPoint("Whole Fruit", "Makan utuh lebih baik daripada dijus agar serat tidak hilang."),
                            _buildBulletPoint("Cuci Bersih", "Rendam air garam sebentar untuk membuang pestisida."),
                            _buildBulletPoint("Mix & Match", "Campur dengan yogurt plain untuk protein."),
                            const SizedBox(height: 32),

                            // Kotak Tips
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.pink.withOpacity(0.1),
                                border: const Border(left: BorderSide(color: Colors.pink, width: 4)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("SUGAR ALERT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                                  SizedBox(height: 8),
                                  Text(
                                    "Hindari buah kering (kismis/kurma) atau buah kalengan jika sedang membatasi gula, karena kandungan gulanya jauh lebih tinggi.",
                                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )))
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- DAILY GOALS ---
// --- DAILY GOALS (4 KATEGORI LENGKAP) ---
              // ==============================================================
              // BAGIAN DAILY GOALS (SIMPLE & ELEGAN)
              // ==============================================================
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Goals',
                      style: TextStyle(
                        fontSize: 20, // Ukuran font sedikit dikecilkan agar lebih elegan
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B), // Dark Navy
                      ),
                    ),
                    // Indikator simpel
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text("4 Missions", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 1. FISIK (Orange)
              _buildGoalCard(
                  title: "Physical Activity",
                  subtitle: "Cardio, Strength, & Stretch",
                  icon: Icons.fitness_center_rounded,
                  // HANYA BUTUH SATU WARNA UTAMA
                  iconThemeColor: primaryOrange,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MissionListPage(
                      title: "Physical Mission", color: primaryOrange,
                      missions: [
                        MissionItem(task: "Peregangan Pagi", subtitle: "5 menit peregangan otot", icon: Icons.accessibility_new),
                        MissionItem(task: "Jalan Kaki Ringan", subtitle: "Minimal 3000 langkah", icon: Icons.directions_walk),
                        MissionItem(task: "Push Up 10x", subtitle: "Kuatkan otot lengan & dada", icon: Icons.fitness_center),
                        MissionItem(task: "Jumping Jacks", subtitle: "20 kali untuk kardio cepat", icon: Icons.bolt),
                        MissionItem(task: "Squat 15x", subtitle: "Kencangkan otot kaki", icon: Icons.airline_seat_legroom_extra),
                        MissionItem(task: "Plank 30 Detik", subtitle: "Latih otot perut", icon: Icons.timer),
                        MissionItem(task: "Pendinginan", subtitle: "Tarik napas & rileks", icon: Icons.self_improvement),
                      ]
                  )))
              ),

              // 2. AIR (Blue)
              _buildGoalCard(
                  title: "Hydration Master",
                  subtitle: "Target: 2000ml Water Intake",
                  icon: Icons.water_drop_rounded,
                  iconThemeColor: Colors.blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MissionListPage(
                      title: "Hydration Mission", color: Colors.blue,
                      missions: [
                        MissionItem(task: "Morning Glass", subtitle: "Bangun tidur (500ml)", icon: Icons.wb_sunny),
                        MissionItem(task: "After Coffee", subtitle: "Netralkan kafein", icon: Icons.coffee),
                        MissionItem(task: "Mid-Morning Sip", subtitle: "Jam 10:00 pagi", icon: Icons.watch_later),
                        MissionItem(task: "Lunch Companion", subtitle: "Sebelum makan siang", icon: Icons.restaurant),
                        MissionItem(task: "Afternoon Refresh", subtitle: "Jam 15:00 sore", icon: Icons.wb_twilight),
                        MissionItem(task: "Dinner Glass", subtitle: "Saat makan malam", icon: Icons.dinner_dining),
                        MissionItem(task: "Night Cap", subtitle: "1 jam sebelum tidur", icon: Icons.nightlight_round),
                      ]
                  )))
              ),

              // 3. ZEN MODE (Purple)
              _buildGoalCard(
                  title: "Zen Mindfulness",
                  subtitle: "Meditation & Gratitude",
                  icon: Icons.spa_rounded,
                  iconThemeColor: premiumPurple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MissionListPage(
                      title: "Mindfulness", color: premiumPurple,
                      missions: [
                        MissionItem(task: "5 Min Breathwork", subtitle: "Tarik napas, tahan, hembuskan", icon: Icons.air),
                        MissionItem(task: "Gratitude Journal", subtitle: "Tulis 3 hal yang disyukuri", icon: Icons.book),
                        MissionItem(task: "No Social Media", subtitle: "1 jam detoks digital", icon: Icons.phonelink_off),
                        MissionItem(task: "Listen to Music", subtitle: "Lagu yang menenangkan", icon: Icons.music_note),
                        MissionItem(task: "Look at the Sky", subtitle: "Istirahatkan mata sejenak", icon: Icons.cloud),
                        MissionItem(task: "Positive Affirmation", subtitle: "Katakan 'Aku Hebat' di cermin", icon: Icons.sentiment_satisfied_alt),
                        MissionItem(task: "Smile Therapy", subtitle: "Senyum selama 30 detik", icon: Icons.mood),
                      ]
                  )))
              ),

              // 4. DEEP SLEEP (Indigo)
              _buildGoalCard(
                  title: "Deep Sleep Ritual",
                  subtitle: "Quality Rest Preparation",
                  icon: Icons.nights_stay_rounded,
                  iconThemeColor: deepIndigo,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MissionListPage(
                      title: "Sleep Hygiene", color: deepIndigo,
                      missions: [
                        MissionItem(task: "Stop Kafein", subtitle: "Tidak ngopi setelah jam 2 siang", icon: Icons.no_drinks),
                        MissionItem(task: "Warm Shower", subtitle: "Relaksasi otot tubuh", icon: Icons.shower),
                        MissionItem(task: "Put Phone Away", subtitle: "1 jam sebelum tidur", icon: Icons.do_not_disturb_on),
                        MissionItem(task: "Read a Physical Book", subtitle: "Hindari cahaya biru layar", icon: Icons.menu_book),
                        MissionItem(task: "Room Temp 22°C", subtitle: "Suhu optimal untuk tidur", icon: Icons.thermostat),
                        MissionItem(task: "Dim the Lights", subtitle: "Ciptakan suasana redup", icon: Icons.lightbulb_outline),
                        MissionItem(task: "Pray / Meditate", subtitle: "Tenangkan pikiran", icon: Icons.spa),
                      ]
                  )))
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  // 1. Helpers untuk Artikel Premium
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
    );
  }

  Widget _buildBulletPoint(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.check_circle, size: 16, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF475569)),
                children: [
                  TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy)),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(String name, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.fiber_manual_record, size: 10, color: primaryOrange), // Dot accent
            const SizedBox(width: 12),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: darkNavy)),
            const Spacer(),
            Text(detail, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  // 2. Helpers untuk Dashboard UI
  Widget _buildDateItem({required String dayName, required String dayDate, bool isSelected = false, bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12), width: 60, height: 80,
      decoration: BoxDecoration(
          color: isSelected ? primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            if (isSelected)
              BoxShadow(color: primaryOrange.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
            else
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))
          ]
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(dayName, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey)),
        const SizedBox(height: 4),
        Text(dayDate, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
        const SizedBox(height: 8),
        if (isActive) Container(width: 6, height: 6, decoration: BoxDecoration(color: isSelected ? Colors.white : primaryOrange, shape: BoxShape.circle))
      ]),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: 260, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))]
            ),
            child: Row(children: [
              // --- BAGIAN INI DITAMBAHKAN HERO ---
              Hero(
                tag: title, // Tag harus unik (kita pakai judul artikel)
                child: Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, size: 30, color: iconColor)
                ),
              ),
              // ------------------------------------

              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.grey))
              ]))
            ])
        )
    );
  }

// =========================================================
  // UPDATED WIDGET: _buildGoalCard (SIMPLE & ELEGAN)
  // =========================================================
  Widget _buildGoalCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconThemeColor, // Hanya butuh satu warna tema
    required VoidCallback onTap
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: const EdgeInsets.only(bottom: 16), // Jarak standar
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), // Sudut membulat yang halus
                border: Border.all(color: Colors.grey.shade200, width: 1), // Border tipis
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03), // Shadow sangat halus, hampir tidak terlihat
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
            ),
            child: Row(children: [
              // --- BAGIAN ICON YANG DIUBAH JADI SIMPEL ---
              Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    // Latar belakang: Warna tema dengan opasitas sangat rendah (tinted)
                    color: iconThemeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14), // Squircle halus
                    // TIDAK ADA GRADASI, TIDAK ADA GLOW BERLEBIHAN
                  ),
                  // Ikonnya sendiri berwarna solid sesuai tema
                  child: Icon(icon, color: iconThemeColor, size: 26)
              ),
              // -------------------------------------------

              const SizedBox(width: 16),

              // TEXT CONTENT
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                        const SizedBox(height: 4),
                        Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4))
                      ]
                  )
              ),

              // ARROW SIMPLE
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 20)
            ])
        )
    );
  }
}

// =========================================================
// 3. ARTICLE DETAIL PAGE (PREMIUM LAYOUT)
// =========================================================
class ArticleDetailPage extends StatelessWidget {
  final String title;
  final String category;
  final String readTime;
  final IconData icon;
  final Color accentColor;
  final List<Widget> contentWidgets;

  const ArticleDetailPage({
    Key? key,
    required this.title,
    this.category = "Healthy Living",
    this.readTime = "3 min read",
    required this.icon,
    required this.accentColor,
    required this.contentWidgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border, color: darkNavy), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_outlined, color: darkNavy), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HERO SECTION
            Container(
              width: double.infinity, height: 220,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // --- PERUBAHAN DI SINI: BUNGKUS ICON DENGAN HERO ---
                  Hero(
                    tag: title, // Tag harus sama dengan yang di Dashboard
                    child: Icon(icon, size: 100, color: accentColor.withOpacity(0.8)),
                  ),
                  // ---------------------------------------------------

                  Positioned(
                    bottom: 16, right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                      ),
                      child: Row(children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(readTime, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                      ]),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // METADATA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(category.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 1)),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: darkNavy, height: 1.2)),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: 24),

            // CONTENT BODY
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: contentWidgets),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// 4. MISSION LIST PAGE (DEPENDENCY FOR GOAL CARDS)
// =========================================================
// =========================================================
// 4. MISSION LIST PAGE (LUXURY LIST DESIGN)
// =========================================================

// Updated Model: Ditambahkan 'subtitle' dan 'icon'
class MissionItem {
  String task;
  String subtitle;
  IconData icon;
  bool isCompleted;

  MissionItem({
    required this.task,
    required this.subtitle,
    required this.icon,
    this.isCompleted = false
  });
}

class MissionListPage extends StatefulWidget {
  final String title;
  final Color color;
  final List<MissionItem> missions;

  const MissionListPage({Key? key, required this.title, required this.color, required this.missions}) : super(key: key);

  @override
  State<MissionListPage> createState() => _MissionListPageState();
}

class _MissionListPageState extends State<MissionListPage> {
  // Hitung progress bar
  double get progress {
    int total = widget.missions.length;
    int completed = widget.missions.where((m) => m.isCompleted).length;
    return total == 0 ? 0 : completed / total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Background sedikit abu-abu sangat muda
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: darkNavy, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
            child: const Icon(Icons.arrow_back, color: darkNavy, size: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          // --- HEADER PROGRESS ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Today's Progress", style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
                    Text("${(progress * 100).toInt()}%", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: widget.color)),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: widget.color.withOpacity(0.1),
                    color: widget.color,
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- LUXURY LIST ITEMS ---
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              itemCount: widget.missions.length,
              separatorBuilder: (c, i) => const SizedBox(height: 16),
              itemBuilder: (ctx, i) {
                final item = widget.missions[i];
                return _buildMissionTile(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget List Item yang Mewah
  Widget _buildMissionTile(MissionItem item) {
    bool isDone = item.isCompleted;

    return GestureDetector(
      onTap: () {
        setState(() {
          item.isCompleted = !item.isCompleted;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDone ? widget.color.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDone ? widget.color.withOpacity(0.3) : Colors.transparent,
              width: 1.5
          ),
          boxShadow: [
            BoxShadow(
              color: isDone ? widget.color.withOpacity(0.05) : Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            // ICON BOX (ANIMATED)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: isDone ? widget.color : widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                isDone ? Icons.check : item.icon,
                color: isDone ? Colors.white : widget.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // TEXT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.task,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDone ? darkNavy.withOpacity(0.6) : darkNavy,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDone ? Colors.grey.withOpacity(0.6) : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // CHECKBOX VISUAL (SIMPLE CIRCLE IF NOT DONE)
            if (!isDone)
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
