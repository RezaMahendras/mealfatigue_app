import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile_page.dart';
import 'notifications.dart';
import 'security.dart';
import 'helpcenter.dart';
import 'admin_page.dart';

const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = "Loading...";
  String nickName = "";
  String email = "";
  String phone = "";
  String age = "";
  String height = "";
  String weight = "";
  String status = "";

  String? avatarUrl;
  bool isLoading = true;

  int _adminClickCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final data = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (data != null) {
          setState(() {
            fullName = data['full_name'] ?? "User";
            nickName = data['nickname'] ?? "";
            email = user.email ?? "";
            phone = data['phone'] ?? "";
            age = data['age']?.toString() ?? "";
            height = data['height']?.toString() ?? "";
            weight = data['weight']?.toString() ?? "";
            status = data['status'] ?? "Mahasiswa";
            avatarUrl = data['avatar_url'];
            isLoading = false;
          });
        } else {
          setState(() {
            email = user.email ?? "";
            fullName = "Set your name";
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
      setState(() => isLoading = false);
    }
  }

  void _showAdminAccessDialog() {
    final TextEditingController _passController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: cardSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.apple, size: 35, color: darkNavy),
              ),
              const SizedBox(height: 20),
              const Text(
                "System Access",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkNavy),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter admin passcode to continue",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _passController,
                obscureText: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(letterSpacing: 12, fontSize: 22, fontWeight: FontWeight.bold, color: darkNavy),
                decoration: InputDecoration(
                  hintText: "••••",
                  hintStyle: const TextStyle(letterSpacing: 12, color: Colors.grey),
                  filled: true,
                  fillColor: cardSurface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        _adminClickCount = 0;
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_passController.text == "12345678910") {
                          _adminClickCount = 0;
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminPage()),
                          );
                        } else {
                          _adminClickCount = 0;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Passcode Incorrect")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: primaryOrange),
                      child: const Text("Verify", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void _navigateToEdit() async {
    Map<String, dynamic> currentData = {
      'full_name': fullName,
      'nickname': nickName,
      'email': email,
      'phone': phone,
      'age': age,
      'height': height,
      'weight': weight,
      'status': status,
      'avatar_url': avatarUrl,
    };

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(currentData: currentData)
        )
    );

    _loadProfile();
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded, size: 32, color: Colors.red),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Log Out?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkNavy),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Are you sure you want to log out from your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await Supabase.instance.client.auth.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil('/auth_choice', (route) => false);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Yes, Logout", style: TextStyle(color: Colors.white)),
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

    bool hasImage = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("My Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: darkNavy)),
                  Material(
                    color: Colors.transparent,
                    child: InkResponse(
                      onTap: () {
                        _adminClickCount++;
                        if (_adminClickCount == 20) {
                          _showAdminAccessDialog();
                        }
                      },
                      child: Icon(Icons.settings, color: Colors.grey.shade400),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
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
                              image: NetworkImage(avatarUrl!),
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
                          child: InkWell(
                            onTap: _navigateToEdit,
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
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
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
              Column(
                children: [
                  _buildMenuItem(Icons.person_outline, "Account Info", onTap: _navigateToEdit),
                  const SizedBox(height: 12),
                  _buildMenuItem(Icons.notifications_outlined, "Notifications", onTap: () {
                    // Gunakan pushNamed agar konsisten dengan rute di main.dart
                    Navigator.pushNamed(context, '/notifications');
                  }),
                  const SizedBox(height: 12),
                  _buildMenuItem(Icons.shield_outlined, "Security & Privacy", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityPage()));
                  }),
                  const SizedBox(height: 12),
                  _buildMenuItem(Icons.help_outline, "Help Center", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterPage()));
                  }),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showLogoutConfirmation(context),
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

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value.isEmpty ? "0" : value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: darkNavy)),
            const SizedBox(width: 2),
            Text(unit, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildVerticalDivider() => Container(height: 24, width: 1, color: Colors.grey.shade200);

  Widget _buildMenuItem(IconData icon, String title, {required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
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
                child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: darkNavy)),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400)
            ],
          ),
        ),
      ),
    );
  }
}
