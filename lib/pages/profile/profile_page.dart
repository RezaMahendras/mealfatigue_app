import 'dart:io';
import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import '../../database_helper.dart';
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

  String? profilePicPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // 1. FUNGSI LOAD DATA
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
        profilePicPath = data['profilePicturePath'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  // 2. FUNGSI NAVIGASI EDIT
  void _navigateToEdit() async {
    Map<String, dynamic> currentData = {
      'fullName': fullName,
      'nickName': nickName,
      'email': email,
      'phone': phone,
      'age': age,
      'height': height,
      'weight': weight,
      'status': status,
      'profilePicturePath': profilePicPath,
    };

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(currentData: currentData)
        )
    );

    if (result != null) {
      await DatabaseHelper.instance.updateUserProfile(result);
      setState(() {
        fullName = result['fullName'];
        nickName = result['nickName'];
        age = result['age'];
        height = result['height'];
        weight = result['weight'];
        email = result['email'];
        phone = result['phone'];
        status = result['status'];
        profilePicPath = result['profilePicturePath'];
      });
    }
  }

  // --- 3. FUNGSI BARU: CUSTOM LOGOUT DIALOG ---
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Icon Header dengan Background Merah Muda
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded, size: 32, color: Colors.red),
                ),
                const SizedBox(height: 20),

                // Judul
                const Text(
                  "Log Out?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkNavy),
                ),
                const SizedBox(height: 8),

                // Deskripsi
                const Text(
                  "Are you sure you want to log out from your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Tombol Aksi
                Row(
                  children: [
                    // Tombol Cancel
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: darkNavy, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Tombol Yes, Logout
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false); // Logout process
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0
                        ),
                        child: const Text("Yes, Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: primaryOrange)),
      );
    }

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
              // HEADER TITLE
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

              // PROFILE INFO
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
                          image: hasImage
                              ? DecorationImage(
                              image: FileImage(File(profilePicPath!)),
                              fit: BoxFit.cover
                          )
                              : null,
                        ),
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

              // STATS CARD
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

              // MENU LIST
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

              // --- 5. LOGOUT BUTTON (DIPERBARUI) ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  // Panggil fungsi dialog di sini
                  onPressed: () => _showLogoutConfirmation(context),
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
