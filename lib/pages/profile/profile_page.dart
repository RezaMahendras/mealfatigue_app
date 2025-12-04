import 'package:flutter/material.dart';
import 'edit_profile_page.dart'; // Import halaman edit

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // DATA PROFIL (Disimpan di State Sementara)
  // Default awal sebelum diedit
  String fullName = "Mastur";
  String nickName = "Mas";
  String email = "mastur@student.uin.ac.id";
  String phone = "081234567890";
  String age = "22";
  String height = "175";
  String weight = "65";
  String status = "Mahasiswa";

  // Fungsi Pindah ke Halaman Edit
  void _navigateToEdit() async {
    // 1. Siapkan data saat ini untuk dikirim
    Map<String, String> currentData = {
      'fullName': fullName,
      'nickName': nickName,
      'email': email,
      'phone': phone,
      'age': age,
      'height': height,
      'weight': weight,
      'status': status,
    };

    // 2. Buka Halaman Edit dan TUNGGU hasilnya (await)
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(currentData: currentData)
        )
    );

    // 3. Jika ada hasil data balik (tombol simpan ditekan)
    if (result != null && result is Map<String, String>) {
      setState(() {
        fullName = result['fullName']!;
        nickName = result['nickName']!;
        age = result['age']!;
        height = result['height']!;
        weight = result['weight']!;
        email = result['email']!;
        phone = result['phone']!;
        status = result['status']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF2ED),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // --- FOTO & ICON EDIT ---
              Center(
                child: Stack(
                  children: [
                    Container(width: 110, height: 110, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]), child: const Icon(Icons.person, size: 60, color: Colors.grey)),
                    Positioned(bottom: 0, right: 0, child: GestureDetector(
                        onTap: _navigateToEdit, // Klik Edit
                        child: Container(height: 36, width: 36, decoration: BoxDecoration(color: const Color(0xFFFF6B4A), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.edit, color: Colors.white, size: 18))
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- NAMA & STATUS ---
              Text(fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
              const SizedBox(height: 4),
              Text(email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(10)), child: Text(status, style: TextStyle(fontSize: 12, color: Colors.orange.shade800, fontWeight: FontWeight.bold))),

              const SizedBox(height: 32),

              // --- STATISTIK ---
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _stat("Age", age, "Years"),
                    Container(width: 1, height: 40, color: Colors.grey.shade200),
                    _stat("Weight", weight, "Kg"),
                    Container(width: 1, height: 40, color: Colors.grey.shade200),
                    _stat("Height", height, "Cm"),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- MENU (Klik Edit Profile juga bisa) ---
              _menu(Icons.person_outline, "Edit Profile", onTap: _navigateToEdit),
              _menu(Icons.notifications_outlined, "Notifications", onTap: (){}),
              _menu(Icons.privacy_tip_outlined, "Privacy Policy", onTap: (){}),
              _menu(Icons.help_outline, "Help Center", onTap: (){}),

              const SizedBox(height: 32),
              SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red, elevation: 0, side: BorderSide(color: Colors.red.shade100), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)), onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false), child: const Text("Log Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String val, String unit) => Column(children: [Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6B4A))), const SizedBox(height: 4), Text("$label ($unit)", style: const TextStyle(fontSize: 12, color: Colors.grey))]);

  Widget _menu(IconData icon, String title, {required VoidCallback onTap}) {
    return Container(margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: ListTile(leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: const Color(0xFF2D2D2D), size: 22)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), onTap: onTap));
  }
}
