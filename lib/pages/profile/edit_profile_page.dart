import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class EditProfilePage extends StatefulWidget {
  // [PERBAIKAN DI SINI] Ubah tipe data jadi dynamic agar cocok dengan ProfilePage
  final Map<String, dynamic> currentData;

  const EditProfilePage({Key? key, required this.currentData}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController nicknameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController weightCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  String? selectedStatus;
  final List<String> statusOptions = ['Mahasiswa', 'Pekerja', 'Lainnya'];

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // [SAFETY] Gunakan .toString() untuk jaga-jaga jika data bukan String murni
    nameCtrl = TextEditingController(text: widget.currentData['fullName']?.toString() ?? '');
    nicknameCtrl = TextEditingController(text: widget.currentData['nickName']?.toString() ?? '');
    ageCtrl = TextEditingController(text: widget.currentData['age']?.toString() ?? '');
    heightCtrl = TextEditingController(text: widget.currentData['height']?.toString() ?? '');
    weightCtrl = TextEditingController(text: widget.currentData['weight']?.toString() ?? '');
    emailCtrl = TextEditingController(text: widget.currentData['email']?.toString() ?? '');
    phoneCtrl = TextEditingController(text: widget.currentData['phone']?.toString() ?? '');

    String? statusAwal = widget.currentData['status']?.toString();
    if (statusAwal != null && statusOptions.contains(statusAwal)) {
      selectedStatus = statusAwal;
    }
  }

  Future<void> _getFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Logic Path Gambar
      String finalImagePath = _imageFile?.path ?? widget.currentData['profilePicturePath']?.toString() ?? '';

      // Kirim data sebagai dynamic agar ProfilePage bisa menerimanya
      Map<String, dynamic> newData = {
        'fullName': nameCtrl.text,
        'nickName': nicknameCtrl.text,
        'age': ageCtrl.text,
        'height': heightCtrl.text,
        'weight': weightCtrl.text,
        'email': emailCtrl.text,
        'phone': phoneCtrl.text,
        'status': selectedStatus ?? 'Mahasiswa',
        'profilePicturePath': finalImagePath,
      };

      Navigator.pop(context, newData);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text('Changes saved successfully'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic Tampilan Gambar
    String? oldPath = widget.currentData['profilePicturePath']?.toString();
    bool hasOldImage = oldPath != null && oldPath.isNotEmpty && File(oldPath).existsSync();

    ImageProvider? displayImage;
    if (_imageFile != null) {
      displayImage = FileImage(_imageFile!);
    } else if (hasOldImage) {
      displayImage = FileImage(File(oldPath));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Edit Profile", style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 16)),
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: _saveData,
              child: const Text("Done", style: TextStyle(color: primaryOrange, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- FOTO PROFIL ---
              GestureDetector(
                onTap: _getFromGallery,
                child: Stack(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: cardSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                        image: displayImage != null
                            ? DecorationImage(image: displayImage, fit: BoxFit.cover)
                            : null,
                      ),
                      child: displayImage == null
                          ? const Icon(Icons.person, size: 40, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: primaryOrange, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- FORM FIELDS ---
              _buildCompactField("Full Name", nameCtrl),
              const SizedBox(height: 12),
              _buildCompactField("Nickname", nicknameCtrl),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: _buildCompactField("Age", ageCtrl, isNumber: true, suffix: "yo")),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCompactField("Height", heightCtrl, isNumber: true, suffix: "cm")),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCompactField("Weight", weightCtrl, isNumber: true, suffix: "kg")),
                ],
              ),
              const SizedBox(height: 12),

              _buildDropdownField(),
              const SizedBox(height: 12),

              _buildCompactField("Email", emailCtrl, isEmail: true),
              const SizedBox(height: 12),
              _buildCompactField("Phone", phoneCtrl, isNumber: true),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactField(String label, TextEditingController ctrl, {bool isNumber = false, bool isEmail = false, String? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
        const SizedBox(height: 6),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: ctrl,
            keyboardType: isNumber ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text),
            style: const TextStyle(fontSize: 14, color: darkNavy, fontWeight: FontWeight.w600),
            cursorColor: primaryOrange,
            decoration: InputDecoration(
              filled: true,
              fillColor: cardSurface,
              suffixText: suffix,
              suffixStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryOrange, width: 1)),
            ),
            validator: (v) => v!.isEmpty ? '' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Status", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cardSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
              style: const TextStyle(fontSize: 14, color: darkNavy, fontWeight: FontWeight.w600),
              items: statusOptions.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (newValue) => setState(() => selectedStatus = newValue),
              dropdownColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
