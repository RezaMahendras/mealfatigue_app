import 'package:flutter/material.dart';

// Definisi Warna (Konsisten dengan Profile)
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _faceIdEnabled = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // --- PERUBAHAN DI SINI: Tombol Kembali Custom ---
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            padding: EdgeInsets.zero, // Agar icon pas di tengah
            icon: const Icon(Icons.arrow_back, color: darkNavy, size: 20),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        // ------------------------------------------------
        title: const Text(
          "Security & Privacy",
          style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            "Account Security",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),

          _buildActionItem(
              title: "Change Password",
              onTap: () {
                // Logika ganti password di sini
              }
          ),
          const SizedBox(height: 12),
          _buildActionItem(
              title: "Two-Factor Authentication",
              onTap: () {}
          ),

          const SizedBox(height: 32),
          const Text(
            "Device Security",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),

          _buildSwitchItem(
            title: "Face ID / Touch ID",
            value: _faceIdEnabled,
            onChanged: (val) => setState(() => _faceIdEnabled = val),
          ),
          const SizedBox(height: 12),
          _buildSwitchItem(
            title: "Remember Me",
            value: _rememberMe,
            onChanged: (val) => setState(() => _rememberMe = val),
          ),

          const SizedBox(height: 32),
          const Text(
            "Privacy",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildActionItem(
              title: "Privacy Policy",
              onTap: () {}
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({required String title, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: darkNavy)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildSwitchItem({required String title, required bool value, required Function(bool) onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        activeColor: primaryOrange,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: darkNavy)),
        value: value,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
