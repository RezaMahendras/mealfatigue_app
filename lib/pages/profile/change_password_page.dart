import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  static const primaryOrange = Color(0xFFFF6B4A);
  static const textColor = Color(0xFF333333);

  Future<void> _handleChangePassword() async {
    String newPass = _newPassCtrl.text.trim();
    String confirmPass = _confirmPassCtrl.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      _showSnackbar("Please fill all fields", Colors.black);
      return;
    }

    if (newPass != confirmPass) {
      _showSnackbar("New passwords do not match", Colors.red);
      return;
    }

    if (newPass.length < 8) {
      _showSnackbar("Password must be at least 8 characters", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: newPass,
        ),
      );

      if (!mounted) return;
      _showSnackbar("Password updated successfully!", Colors.green);

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);

    } on AuthException catch (error) {
      if (mounted) _showSnackbar(error.message, Colors.red);
    } catch (error) {
      if (mounted) _showSnackbar("An unexpected error occurred", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 18, color: textColor),
                    SizedBox(width: 8),
                    Text(
                        'Change Password',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Create a new password that is strong and unique to secure your account.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _newPassCtrl,
                obscureText: _obscureNew,
                decoration: inputDecoration.copyWith(
                  hintText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureNew ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey, size: 20
                    ),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPassCtrl,
                obscureText: _obscureConfirm,
                decoration: inputDecoration.copyWith(
                  hintText: 'Confirm New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey, size: 20
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLoginCheck,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                      height: 24, width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                      : const Text(
                      "Update Password",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLoginCheck() => _handleChangePassword();
}
