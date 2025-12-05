import 'package:flutter/material.dart';
import '../../database_helper.dart'; // Pastikan path ini sesuai dengan struktur folder Anda

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class CoupleProfilePage extends StatefulWidget {
  const CoupleProfilePage({Key? key}) : super(key: key);

  @override
  State<CoupleProfilePage> createState() => _CoupleProfilePageState();
}

class _CoupleProfilePageState extends State<CoupleProfilePage> {
  Map<String, dynamic> profileData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // --- PERBAIKAN 1: Load Data dengan Error Handling ---
  Future<void> _loadData() async {
    try {
      final data = await DatabaseHelper.instance.getCoupleProfile();
      if (mounted) {
        setState(() {
          if (data != null) {
            profileData = Map.from(data);
          } else {
            // Jika data kosong (jarang terjadi karena ada default data), inisialisasi map kosong
            profileData = {};
          }
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // --- HELPER CHIPS ---
  List<Widget> _buildCompactChips(String commaSeparatedString, Color color, bool isAlert) {
    if (commaSeparatedString.isEmpty) {
      return [Text("-", style: TextStyle(fontSize: 12, color: Colors.grey.shade400))];
    }
    List<String> tags = commaSeparatedString.split(',');
    return tags.map((tag) => Container(
      margin: const EdgeInsets.only(right: 6, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAlert ? Colors.red.shade50 : cardSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isAlert ? Colors.red.withOpacity(0.2) : color.withOpacity(0.2)),
      ),
      child: Text(
          tag.trim(),
          style: TextStyle(
              fontSize: 11,
              color: isAlert ? Colors.red.shade700 : darkNavy,
              fontWeight: FontWeight.w600
          )
      ),
    )).toList();
  }

  // --- DIALOG EDIT ---
  void _showEditDialog(String personType) {
    String nameKey = personType == 'A' ? 'person_a_name' : 'person_b_name';
    String needsKey = personType == 'A' ? 'person_a_needs' : 'person_b_needs';
    String prefsKey = personType == 'A' ? 'person_a_prefs' : 'person_b_prefs';
    String allergiesKey = personType == 'A' ? 'person_a_allergies' : 'person_b_allergies';

    TextEditingController nameController = TextEditingController(text: profileData[nameKey]);
    TextEditingController needsController = TextEditingController(text: profileData[needsKey]);
    TextEditingController prefsController = TextEditingController(text: profileData[prefsKey]);
    TextEditingController allergiesController = TextEditingController(text: profileData[allergiesKey]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Edit Person $personType", style: const TextStyle(color: darkNavy, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogInput(nameController, "Nama"),
              const SizedBox(height: 12),
              _buildDialogInput(needsController, "Dietary Needs (pisahkan koma)"),
              const SizedBox(height: 12),
              _buildDialogInput(prefsController, "Preferences (pisahkan koma)"),
              const SizedBox(height: 12),
              _buildDialogInput(allergiesController, "Allergies (pisahkan koma)"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal", style: TextStyle(color: Colors.grey))),

          // --- PERBAIKAN 2: Tombol Simpan Terkoneksi Database ---
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async {
              // 1. Siapkan data baru
              Map<String, dynamic> updatedData = Map.from(profileData);
              updatedData[nameKey] = nameController.text;
              updatedData[needsKey] = needsController.text;
              updatedData[prefsKey] = prefsController.text;
              updatedData[allergiesKey] = allergiesController.text;

              // Update analisis AI (Simulasi update logic)
              updatedData['ai_analysis'] = "AI Understanding updated for ${nameController.text}.";

              try {
                // 2. SIMPAN KE DATABASE (Panggil fungsi dari DatabaseHelper)
                await DatabaseHelper.instance.updateCoupleProfile(updatedData);

                // 3. Update Tampilan UI jika berhasil
                if (mounted) {
                  setState(() {
                    profileData = updatedData;
                  });
                  Navigator.pop(context); // Tutup dialog

                  // Tampilkan notifikasi kecil
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profil berhasil disimpan!"),
                      duration: Duration(seconds: 1),
                      backgroundColor: primaryOrange,
                    ),
                  );
                }
              } catch (e) {
                // Handle Error
                debugPrint("Gagal menyimpan ke database: $e");
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menyimpan: $e")),
                  );
                }
              }
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildDialogInput(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14, color: darkNavy),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        filled: true, fillColor: cardSurface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryOrange, width: 1.5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Couple Profil", style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold)),
        centerTitle: true,
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryOrange))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            const Text("Understanding your unique needs", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),

            // --- KARTU PERSON A (COWO) ---
            _buildCompactPersonCard(
              type: "A",
              name: profileData['person_a_name'] ?? "Person A",
              needs: profileData['person_a_needs'] ?? "",
              prefs: profileData['person_a_prefs'] ?? "",
              allergies: profileData['person_a_allergies'] ?? "",
              isMale: true,
            ),

            const SizedBox(height: 16),

            // --- KARTU PERSON B (CEWE) ---
            _buildCompactPersonCard(
              type: "B",
              name: profileData['person_b_name'] ?? "Person B",
              needs: profileData['person_b_needs'] ?? "",
              prefs: profileData['person_b_prefs'] ?? "",
              allergies: profileData['person_b_allergies'] ?? "",
              isMale: false,
            ),

            const SizedBox(height: 16),

            // --- KARTU RELATIONSHIP ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [Icon(Icons.favorite, size: 18, color: primaryOrange), SizedBox(width: 8), Text("Relationship Dynamic", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: darkNavy))]),
                  const SizedBox(height: 8),
                  Text('"${profileData['dynamic_problem'] ?? "No dynamic problem recorded."}"', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: primaryOrange.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryOrange.withOpacity(0.1))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: const [Icon(Icons.auto_awesome, size: 14, color: primaryOrange), SizedBox(width: 6), Text("AI Insight", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: primaryOrange))]),
                      const SizedBox(height: 4),
                      Text(profileData['ai_analysis'] ?? "No AI analysis available.", style: const TextStyle(fontSize: 12, color: darkNavy, height: 1.4)),
                    ]),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER: COMPACT PERSON CARD ---
  Widget _buildCompactPersonCard({
    required String type,
    required String name,
    required String needs,
    required String prefs,
    required String allergies,
    required bool isMale,
  }) {
    // Definisi Warna & Icon berdasarkan Gender
    final Color avatarBgColor = isMale ? const Color(0xFFE3F2FD) : const Color(0xFFFCE4EC);
    final Color avatarIconColor = isMale ? const Color(0xFF1565C0) : const Color(0xFFD81B60);
    final IconData avatarIcon = isMale ? Icons.male : Icons.female;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: avatarBgColor,
                    child: Icon(avatarIcon, size: 20, color: avatarIconColor),
                  ),
                  const SizedBox(width: 10),
                  // Nama
                  Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: darkNavy)),
                ],
              ),
              InkWell(
                onTap: () => _showEditDialog(type),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.edit, size: 16, color: Colors.grey),
                ),
              )
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 12),

          _buildCompactRow(Icons.restaurant_menu, "Diet", needs, primaryOrange, false),
          const SizedBox(height: 8),
          _buildCompactRow(Icons.favorite_border, "Likes", prefs, darkNavy, false),
          const SizedBox(height: 8),
          _buildCompactRow(Icons.warning_amber_rounded, "Allergy", allergies, Colors.red, true),
        ],
      ),
    );
  }

  Widget _buildCompactRow(IconData icon, String label, String data, Color color, bool isAlert) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Expanded(
          child: Wrap(
            children: _buildCompactChips(data, color, isAlert),
          ),
        ),
      ],
    );
  }
}
