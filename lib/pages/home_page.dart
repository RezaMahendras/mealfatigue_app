import 'package:flutter/material.dart';
import 'profile_page.dart'; // <--- JANGAN LUPA IMPORT INI

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardTab(),
    const PlaceholderPage(title: 'Keranjang'),
    const PlaceholderPage(title: 'Menu Koki'),
    const PlaceholderPage(title: 'Favorit'),
    const ProfilePage(), // <--- Memanggil Class dari file profile_page.dart
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF6B4A),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Chef'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Love'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// DASHBOARD TAB (Code tetap sama, hanya ProfileTab dihapus)
// ---------------------------------------------------------
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
      backgroundColor: const Color(0xFFFFF2ED),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hi, Mastur!!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.local_fire_department, color: Colors.red, size: 18),
                          SizedBox(width: 4),
                          Text('10 days streak!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Opsi: Navigasi manual ke ProfilePage jika avatar diklik
                      final homeState = context.findAncestorStateOfType<_HomePageState>();
                      homeState?._onItemTapped(4);
                    },
                    child: Container(
                      width: 45, height: 45,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade300)),
                      child: const Icon(Icons.person, color: Color(0xFF2D2D2D)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // Calendar
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

              // Horizontal Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildInfoCard(
                        title: "Eat The Rainbow", subtitle: "Consume a variety of colorful fruits...", color: Colors.orange.shade100, icon: Icons.fastfood,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ArticleDetailPage(
                            title: "Eat The Rainbow", icon: Icons.fastfood, color: Colors.orange, content: "Memakan 'Pelangi' berarti mengonsumsi berbagai macam buah..."
                        )))
                    ),
                    const SizedBox(width: 16),
                    _buildInfoCard(
                        title: "Nutrition Tips", subtitle: "Macronutrients are the essential...", color: Colors.blue.shade100, icon: Icons.lightbulb,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ArticleDetailPage(
                            title: "Nutrition Tips", icon: Icons.lightbulb, color: Colors.blue, content: "Memahami Makronutrisi adalah kunci diet seimbang..."
                        )))
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Daily Goals
              const Text('Daily Goals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
              const SizedBox(height: 16),

              _buildGoalCard(
                  title: "Let's Get Physical", subtitle: "Latihan ringan untuk kebugaran jantung.", icon: Icons.fitness_center, iconColor: Colors.black54,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MissionListPage(
                      title: "Let's Get Physical", color: Colors.orange,
                      missions: [MissionItem(task: "Peregangan Pagi"), MissionItem(task: "Jalan Kaki Ringan"), MissionItem(task: "Push Up 10x")]
                  )))
              ),
              _buildGoalCard(
                  title: "Make Water Your Daily Brew", subtitle: "Target: 2 Liter air hari ini.", icon: Icons.water_drop, iconColor: Colors.blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MissionListPage(
                      title: "Hydration Mission", color: Colors.blue,
                      missions: [MissionItem(task: "Minum 1 gelas bangun tidur"), MissionItem(task: "Minum sebelum makan siang"), MissionItem(task: "Minum sebelum tidur")]
                  )))
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets tetap di sini agar DashboardTab rapi ---
  Widget _buildDateItem({required String dayName, required String dayDate, bool isSelected = false, bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12), width: 60, height: 80,
      decoration: BoxDecoration(color: isSelected ? const Color(0xFFFF6B4A) : Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 4))]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(dayName, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey)), const SizedBox(height: 4), Text(dayDate, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)), const SizedBox(height: 8), if (isActive) Container(width: 6, height: 6, decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.green, shape: BoxShape.circle))]),
    );
  }

  Widget _buildInfoCard({required String title, required String subtitle, required Color color, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(onTap: onTap, child: Container(width: 260, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))]), child: Row(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 30, color: Colors.black54)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), const SizedBox(height: 4), Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.grey))]))])));
  }

  Widget _buildGoalCard({required String title, required String subtitle, required IconData icon, required Color iconColor, required VoidCallback onTap}) {
    return GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))]), child: Row(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 30)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4))])), const SizedBox(width: 8), const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)])));
  }
}

// =========================================================
// HELPER CLASSES (MISI & ARTIKEL)
// (Bisa juga dipisah ke file lain, tapi sementara di sini aman)
// =========================================================

class MissionItem {
  String task; bool isCompleted; MissionItem({required this.task, this.isCompleted = false});
}

class MissionListPage extends StatefulWidget {
  final String title; final Color color; final List<MissionItem> missions;
  const MissionListPage({Key? key, required this.title, required this.color, required this.missions}) : super(key: key);
  @override
  State<MissionListPage> createState() => _MissionListPageState();
}

class _MissionListPageState extends State<MissionListPage> {
  double get progress { int t = widget.missions.length; int c = widget.missions.where((m) => m.isCompleted).length; return t==0?0:c/t;}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, appBar: AppBar(title: Text(widget.title, style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
        body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: widget.color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Daily Progress"), Text("${(progress*100).toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, color: widget.color))]), const SizedBox(height: 10), LinearProgressIndicator(value: progress, backgroundColor: Colors.white, color: widget.color, minHeight: 10, borderRadius: BorderRadius.circular(10))])), const SizedBox(height: 24), Expanded(child: ListView.separated(itemCount: widget.missions.length, separatorBuilder: (c,i)=>const SizedBox(height: 12), itemBuilder: (ctx, i) { final m = widget.missions[i]; return Container(decoration: BoxDecoration(border: Border.all(color: m.isCompleted?widget.color:Colors.grey.shade300), borderRadius: BorderRadius.circular(12)), child: CheckboxListTile(activeColor: widget.color, title: Text(m.task, style: TextStyle(decoration: m.isCompleted?TextDecoration.lineThrough:null, color: m.isCompleted?Colors.grey:Colors.black87)), value: m.isCompleted, onChanged: (v)=>setState(()=>m.isCompleted=v!)));}))]))
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final String title; final String content; final IconData icon; final Color color;
  const ArticleDetailPage({Key? key, required this.title, required this.content, required this.icon, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, appBar: AppBar(title: Text(title, style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)), body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [Container(width: double.infinity, height: 200, decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(20)), child: Center(child: Icon(icon, size: 80, color: color))), const SizedBox(height: 24), Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))), const SizedBox(height: 16), Text(content, style: const TextStyle(fontSize: 16, height: 1.6), textAlign: TextAlign.justify)])));
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title; const PlaceholderPage({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) { return Scaffold(backgroundColor: Colors.white, body: Center(child: Text('Halaman $title', style: const TextStyle(fontSize: 20, color: Colors.grey)))); }
}