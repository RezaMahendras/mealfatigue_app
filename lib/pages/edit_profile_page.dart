import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  // BAGIAN PENTING: Menerima kiriman data dari ProfilePage
  final Map<String, String> currentData;

  const EditProfilePage({Key? key, required this.currentData}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controller text
  late TextEditingController nameCtrl;
  late TextEditingController nicknameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController weightCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  String? selectedStatus;
  final List<String> statusOptions = ['Mahasiswa', 'Pekerja', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    // ISI FORM SESUAI DATA YANG DIKIRIM DARI PROFIL
    nameCtrl = TextEditingController(text: widget.currentData['fullName']);
    nicknameCtrl = TextEditingController(text: widget.currentData['nickName']);
    ageCtrl = TextEditingController(text: widget.currentData['age']);
    heightCtrl = TextEditingController(text: widget.currentData['height']);
    weightCtrl = TextEditingController(text: widget.currentData['weight']);
    emailCtrl = TextEditingController(text: widget.currentData['email']);
    phoneCtrl = TextEditingController(text: widget.currentData['phone']);

    // Cek status dropdown
    String? statusAwal = widget.currentData['status'];
    if (statusOptions.contains(statusAwal)) {
      selectedStatus = statusAwal;
    }
  }

  // FUNGSI SIMPAN & KIRIM BALIK DATA
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Bungkus data baru ke dalam Map
      Map<String, String> newData = {
        'fullName': nameCtrl.text,
        'nickName': nicknameCtrl.text,
        'age': ageCtrl.text,
        'height': heightCtrl.text,
        'weight': weightCtrl.text,
        'email': emailCtrl.text,
        'phone': phoneCtrl.text,
        'status': selectedStatus ?? 'Mahasiswa',
      };

      // KEMBALI KE PROFIL MEMBAWA DATA BARU
      Navigator.pop(context, newData);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text('Profil Diperbarui'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profil", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              icon: const Icon(Icons.check, color: Color(0xFFFF6B4A)),
              onPressed: _saveData // Tombol Centang
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Nama Lengkap"),
              _buildInput(nameCtrl, "Nama Lengkap"),

              _buildLabel("Nama Panggilan"),
              _buildInput(nicknameCtrl, "Panggilan"),

              Row(
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Umur"), _buildInput(ageCtrl, "Thn", isNumber: true)])),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Tinggi"), _buildInput(heightCtrl, "Cm", isNumber: true)])),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Berat"), _buildInput(weightCtrl, "Kg", isNumber: true)])),
                ],
              ),

              _buildLabel("Status"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    hint: const Text("Pilih Status"),
                    isExpanded: true,
                    items: statusOptions.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                    onChanged: (newValue) => setState(() => selectedStatus = newValue),
                  ),
                ),
              ),

              _buildLabel("Email"),
              _buildInput(emailCtrl, "Email", isEmail: true),

              _buildLabel("Nomor HP"),
              _buildInput(phoneCtrl, "Nomor HP", isNumber: true),

              const SizedBox(height: 32),

              // Tombol Simpan Besar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B4A), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _saveData,
                  child: const Text("Simpan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 8.0, top: 16.0), child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)));

  Widget _buildInput(TextEditingController ctrl, String hint, {bool isNumber = false, bool isEmail = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
    );
  }
}