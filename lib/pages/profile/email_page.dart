import 'package:flutter/material.dart';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final _toController = TextEditingController(text: "mealfatigue@gmail.com");

  bool _isLoading = false;

  void _handleSendEmail() async {
    if (_subjectController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Subject and Message cannot be empty"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi pengiriman email
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Email sent successfully! We will reply shortly."),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Compose Email",
          style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold),
        ),
        actions: [
          // [UPDATED] Ikon attachment dihapus di sini
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: _isLoading
                  ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: primaryOrange))
                  : const Icon(Icons.send_rounded, color: primaryOrange),
              onPressed: _isLoading ? null : _handleSendEmail,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // --- KOLOM PENERIMA (READ ONLY) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                const Text("To:", style: TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _toController,
                    readOnly: true, // Tidak bisa diedit user
                    style: const TextStyle(color: darkNavy, fontWeight: FontWeight.w600, fontSize: 16),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- KOLOM SUBJECT ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: TextField(
              controller: _subjectController,
              style: const TextStyle(color: darkNavy, fontSize: 16),
              decoration: const InputDecoration(
                hintText: "Subject",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),

          // --- KOLOM PESAN (BODY) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TextField(
                controller: _bodyController,
                maxLines: null, // Unlimited lines
                expands: true, // Mengisi sisa layar
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(color: darkNavy, fontSize: 16, height: 1.5),
                decoration: const InputDecoration(
                  hintText: "Write your message here...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
