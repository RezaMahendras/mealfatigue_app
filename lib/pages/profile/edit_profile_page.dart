import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> currentData;

  const EditProfilePage({Key? key, required this.currentData}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late TextEditingController nameCtrl;
  late TextEditingController nicknameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController weightCtrl;
  late TextEditingController phoneCtrl;

  String? selectedStatus;
  final List<String> statusOptions = ['Mahasiswa', 'Pekerja', 'Lainnya'];

  File? _imageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.currentData['full_name']?.toString() ?? '');
    nicknameCtrl = TextEditingController(text: widget.currentData['nickname']?.toString() ?? '');
    ageCtrl = TextEditingController(text: widget.currentData['age']?.toString() ?? '');
    heightCtrl = TextEditingController(text: widget.currentData['height']?.toString() ?? '');
    weightCtrl = TextEditingController(text: widget.currentData['weight']?.toString() ?? '');
    phoneCtrl = TextEditingController(text: widget.currentData['phone']?.toString() ?? '');

    String? statusAwal = widget.currentData['status']?.toString();
    if (statusAwal != null && statusOptions.contains(statusAwal)) {
      selectedStatus = statusAwal;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    nicknameCtrl.dispose();
    ageCtrl.dispose();
    heightCtrl.dispose();
    weightCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
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

  void _handleDoneButton() {
    if (_formKey.currentState!.validate()) {
      _showSaveConfirmation(context);
    }
  }

  void _showSaveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.cloud_upload_outlined, size: 50, color: primaryOrange),
            const SizedBox(height: 16),
            const Text(
              "Simpan Perubahan?",
              style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Apakah Anda yakin ingin memperbarui data profil Anda?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 20),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSave();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrange,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Ya, Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _performSave() async {
    setState(() => _isSaving = true);

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      String? avatarUrl = widget.currentData['avatar_url'];

      if (_imageFile != null) {
        final fileExtension = _imageFile!.path.split('.').last;
        final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

        await _supabase.storage.from('avatars').upload(
          fileName,
          _imageFile!,
          fileOptions: const FileOptions(upsert: true),
        );
        avatarUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);
      }

      await _supabase.from('profiles').upsert({
        'id': userId,
        'full_name': nameCtrl.text,
        'nickname': nicknameCtrl.text,
        'age': int.tryParse(ageCtrl.text) ?? 0,
        'height': int.tryParse(heightCtrl.text) ?? 0,
        'weight': int.tryParse(weightCtrl.text) ?? 0,
        'status': selectedStatus ?? 'Lainnya',
        'phone': phoneCtrl.text,
        'avatar_url': avatarUrl,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: darkNavy,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: primaryOrange, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Profil Berhasil Disimpan!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text('Error: $e'))
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (_imageFile != null) {
      imageProvider = FileImage(_imageFile!);
    } else if (widget.currentData['avatar_url'] != null && widget.currentData['avatar_url'].toString().isNotEmpty) {
      imageProvider = NetworkImage(widget.currentData['avatar_url']);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leadingWidth: 80,
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        actions: [
          _isSaving
              ? const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: primaryOrange),
              ),
            ),
          )
              : Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: _handleDoneButton,
              child: const Text(
                "Selesai",
                style: TextStyle(color: primaryOrange, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _getFromGallery,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: cardSurface,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: primaryOrange, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildField("Nama Lengkap", nameCtrl),
              const SizedBox(height: 15),
              _buildField("Nama Panggilan", nicknameCtrl),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildField("Umur", ageCtrl, isNumber: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField("Tinggi (cm)", heightCtrl, isNumber: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField("Berat (kg)", weightCtrl, isNumber: true)),
                ],
              ),
              const SizedBox(height: 15),
              _buildDropdown(),
              const SizedBox(height: 15),
              _buildField("Nomor Telepon", phoneCtrl, isNumber: true),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 14, color: darkNavy, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: cardSurface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Status", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              items: statusOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
          ),
        ),
      ],
    );
  }
}
