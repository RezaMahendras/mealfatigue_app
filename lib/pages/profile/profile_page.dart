import 'dart:io'; // [FIX] Wajib import ini untuk File
import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import '../../database_helper.dart'; // Sesuaikan lokasi jika perlu
import 'notifications.dart';
import 'security.dart';
import 'helpcenter.dart';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variabel Data
  String fullName = "Loading...";
  String nickName = "";
  String email = "";
  String phone = "";
  String age = "";
  String height = "";
  String weight = "";
  String status = "";

  // [FIX] Tambahkan variabel untuk path foto
  String? profilePicPath;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // 1. FUNGSI LOAD DATA DARI DB
  Future<void> _loadProfile() async {
    final data = await DatabaseHelper.instance.getUserProfile();
    if (data != null) {
      setState(() {
        fullName = data['fullName'] ?? "Reza";
        nickName = data['nickName'] ?? "Mahendras";
        email = data['email'] ?? "";
        phone = data['phone'] ?? "";
        age = data['age'] ?? "";
        height = data['height'] ?? "";
        weight = data['weight'] ?? "";
        status = data['status'] ?? "Mahasiswa";
        // [FIX] Ambil path foto dari database
        profilePicPath = data['profilePicturePath'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  // 2. FUNGSI NAVIGASI & SIMPAN KE DB
  void _navigateToEdit() async {
    // [FIX] Masukkan profilePicturePath ke currentData agar bisa dilihat di halaman edit
    Map<String, dynamic> currentData = { // Ubah jadi dynamic agar aman
      'fullName': fullName,
      'nickName': nickName,
      'email': email,
      'phone': phone,
      'age': age,
      'height': height,
      'weight': weight,
      'status': status,
      'profilePicturePath': profilePicPath, // Kirim path saat ini
    };

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(currentData: currentData)
        )
    );

    // [FIX] Update logika penerimaan data
    if (result != null) {
      // Update ke database
      await DatabaseHelper.instance.updateUserProfile(result);

      // Update state lokal (Refresh tampilan)
      setState(() {
        fullName = result['fullName'];
        nickName = result['nickName'];
        age = result['age'];
        height = result['height'];
        weight = result['weight'];
        email = result['email'];
        phone = result['phone'];
        status = result['status'];
        // [FIX] Update path foto yang baru dipilih
        profilePicPath = result['profilePicturePath'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: primaryOrange)),
      );
    }

    // [FIX] Cek validitas gambar sebelum render
    bool hasImage = profilePicPath != null &&
        profilePicPath!.isNotEmpty &&
        File(profilePicPath!).existsSync();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HEADER TITLE ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("My Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: darkNavy)),
                  Material(
                    color: Colors.transparent,
                    child: InkResponse(
                      onTap: (){},
                      radius: 24,
                      child: Icon(Icons.settings, color: Colors.grey.shade400),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),

              // --- 2. PROFILE INFO (UI FOTO DIPERBAIKI) ---
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 84, height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200, width: 1),
                          // [FIX] Tampilkan gambar jika ada
                          image: hasImage
                              ? DecorationImage(
                              image: FileImage(File(profilePicPath!)),
                              fit: BoxFit.cover
                          )
                              : null,
                        ),
                        // [FIX] Jika tidak ada gambar, tampilkan Icon Person
                        child: !hasImage
                            ? const Icon(Icons.person, size: 42, color: darkNavy)
                            : null,
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Material(
                          color: primaryOrange,
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            onTap: _navigateToEdit,
                            customBorder: const CircleBorder(),
                            splashColor: Colors.white.withOpacity(0.3),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2)
                              ),
                              child: const Icon(Icons.edit, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkNavy)),
                        const SizedBox(height: 4),
                        Text(email, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: primaryOrange)
                          ),
                          child: Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: primaryOrange)),
                        )
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 32),

              // --- 3. STATS CARD ---
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                    ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem("Age", age, "yo"),
                    _buildVerticalDivider(),
                    _buildStatItem("Weight", weight, "kg"),
                    _buildVerticalDivider(),
                    _buildStatItem("Height", height, "cm"),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- 4. MENU LIST ---
              Column(
                children: [
                  _buildMenuItem(Icons.person_outline, "Account Info", onTap: _navigateToEdit),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                      Icons.notifications_outlined,
                      "Notifications",
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationsPage())
                        );
                      }
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                      Icons.shield_outlined,
                      "Security & Privacy",
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SecurityPage())
                        );
                      }
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                      Icons.help_outline,
                      "Help Center",
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpCenterPage())
                        );
                      }
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // --- 5. LOGOUT BUTTON ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    splashFactory: InkRipple.splashFactory,
                  ),
                  child: const Text("Log Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: darkNavy)),
            const SizedBox(width: 2),
            Text(unit, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 24, width: 1, color: Colors.grey.shade200);
  }

  Widget _buildMenuItem(IconData icon, String title, {required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        splashColor: primaryOrange.withOpacity(0.1),
        highlightColor: primaryOrange.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: primaryOrange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: darkNavy)
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400)
            ],
          ),
        ),
      ),
    );
  }
}
