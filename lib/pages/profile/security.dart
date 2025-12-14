import 'package:flutter/material.dart';
import '../../database_helper.dart';
import 'legal_content_page.dart';
import 'change_password_page.dart';
import 'change_email_page.dart';

// --- Definisi Warna ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color dangerRed = Color(0xFFEF4444); // Merah yang lebih soft & modern

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {

  final String _privacyText = """
1. Data Collection
We collect information you provide directly to us, such as when you create or modify your account, request on-demand services, contact customer support, or otherwise communicate with us. This information may include: name, email, phone number, and profile picture.

2. Use of Information
We may use the information we collect about you to:
- Provide, maintain, and improve our Services.
- Perform internal operations, including, for example, to prevent fraud and abuse of our Services.
- Send you communications we think will be of interest to you, including information about products, services, promotions, and news.

3. Security
We take reasonable measures to help protect information about you from loss, theft, misuse and unauthorized access, disclosure, alteration and destruction.
  """;

  final String _termsText = """
1. Acceptance of Terms
By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. In addition, when using these particular services, you shall be subject to any posted guidelines or rules applicable to such services.

2. User Conduct
You agree that you will not use the Service for any purpose that is unlawful or prohibited by these Terms. You agree not to access the Service by any means other than through the interface that is provided by Meal Fatigue.

3. Termination
We may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.
  """;

  void _navigateToLegal(String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LegalContentPage(title: title, content: content),
      ),
    );
  }

  // --- LOGIKA DELETE ACCOUNT (TAMPILAN BARU) ---
  void _showDeleteConfirmation(BuildContext context) {
    final passwordCtrl = TextEditingController();
    bool isLoading = false;
    bool obscureText = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Icon Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: dangerRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_forever_rounded, size: 32, color: dangerRed),
                    ),
                    const SizedBox(height: 20),

                    // 2. Title & Subtitle
                    const Text(
                      "Delete Account",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: darkNavy),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This action is permanent. Enter your password to confirm.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                    ),
                    const SizedBox(height: 24),

                    // 3. Input Password (Modern Style)
                    TextField(
                      controller: passwordCtrl,
                      obscureText: obscureText,
                      style: const TextStyle(color: darkNavy, fontWeight: FontWeight.w600),
                      cursorColor: dangerRed,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: dangerRed, width: 1.5),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                              obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey
                          ),
                          onPressed: () => setState(() => obscureText = !obscureText),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Buttons (Cancel & Delete)
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: isLoading ? null : () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () async {
                              String pass = passwordCtrl.text.trim();
                              if (pass.isEmpty) return;

                              setState(() => isLoading = true);

                              // Proses Delete
                              await Future.delayed(const Duration(milliseconds: 1000));
                              String result = await DatabaseHelper.instance.deleteAccount(pass);

                              if (!mounted) return;
                              setState(() => isLoading = false);

                              if (result == "Success") {
                                Navigator.pop(context);
                                // LOGOUT -> LOGIN
                                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Account deleted successfully."),
                                      backgroundColor: darkNavy
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result), backgroundColor: dangerRed),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: dangerRed,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: isLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text("Delete", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: darkNavy, size: 20),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          "Security & Privacy",
          style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // --- SECTION 1: ACCOUNT SECURITY ---
          const Text(
            "Account Security",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),

          _buildActionItem(
              title: "Change Password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                );
              }
          ),
          const SizedBox(height: 12),

          _buildActionItem(
              title: "Change Email",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangeEmailPage()),
                );
              }
          ),

          // --- SECTION 2: PRIVACY ---
          const SizedBox(height: 32),
          const Text(
            "Privacy",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),

          _buildActionItem(
              title: "Privacy Policy",
              onTap: () => _navigateToLegal("Privacy Policy", _privacyText)
          ),
          const SizedBox(height: 12),

          _buildActionItem(
              title: "Terms of Services",
              onTap: () => _navigateToLegal("Terms of Services", _termsText)
          ),

          const SizedBox(height: 50),

          // --- SECTION 3: DANGER ZONE (Updated Visuals) ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: dangerRed.withOpacity(0.04), // Background merah sangat tipis
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: dangerRed.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, size: 18, color: dangerRed),
                    SizedBox(width: 8),
                    Text(
                      "Danger Zone",
                      style: TextStyle(color: dangerRed, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Deleting your account will remove all your data permanently. This action cannot be undone.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => _showDeleteConfirmation(context),
                    style: TextButton.styleFrom(
                      foregroundColor: dangerRed,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: dangerRed.withOpacity(0.3))
                      ),
                      splashFactory: InkRipple.splashFactory,
                    ),
                    child: const Text("Delete Account", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          )
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
}
