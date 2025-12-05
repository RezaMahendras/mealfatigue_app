import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'kos_life_hasil.dart';
import '../../database_helper.dart';
import '../../kos_life_utils.dart';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class KosLifeSetupPage extends StatefulWidget {
  const KosLifeSetupPage({Key? key}) : super(key: key);

  @override
  State<KosLifeSetupPage> createState() => _KosLifeSetupPageState();
}

class _KosLifeSetupPageState extends State<KosLifeSetupPage> {
  String _selectedCondition = "tidak ada";
  String _selectedContext = "normal";
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController(text: "1");

  bool isProcessing = false;

  @override
  void dispose() {
    _budgetController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  // --- LOGIKA UTAMA ---
  void _processAndNavigate() async {
    String rawBudget = _budgetController.text;
    int totalBudget = CurrencyFormat.parseIdr(rawBudget);

    if (totalBudget < 50000) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Minimal budget Rp 50.000 ya"))
      );
      return;
    }

    setState(() => isProcessing = true);
    await Future.delayed(const Duration(seconds: 1));

    // 1. DATA BAHAN MAKANAN (NORMAL & SEDIKIT)
    // Total semua barang ini sekitar Rp 220.000
    List<Map<String, dynamic>> masterItems = [
      // Kebutuhan Pokok (Must)
      {'name': 'Beras 3kg', 'price': 45000, 'category': 'must'},
      {'name': 'Telur 1/2 kg', 'price': 16000, 'category': 'must'},
      {'name': 'Minyak Goreng 1L', 'price': 17000, 'category': 'must'},
      {'name': 'Air Galon', 'price': 20000, 'category': 'must'},
      {'name': 'Bumbu Dapur', 'price': 10000, 'category': 'must'}, // Garam, masako, dll

      // Bahan Makanan Tambahan (Allow)
      {'name': 'Tempe & Tahu', 'price': 12000, 'category': 'allow'},
      {'name': 'Mie Instan (5 bks)', 'price': 16000, 'category': 'allow'},
      {'name': 'Daging Ayam 1/2kg', 'price': 25000, 'category': 'allow'},
      {'name': 'Sayur Sop-sopan', 'price': 10000, 'category': 'allow'},
      {'name': 'Sosis Siap Makan', 'price': 15000, 'category': 'allow'},
      {'name': 'Kopi/Teh Sachet', 'price': 12000, 'category': 'allow'},
      {'name': 'Buah Pisang', 'price': 15000, 'category': 'allow'},
    ];

    // 2. ALGORITMA BELANJA
    List<Map<String, dynamic>> itemsToBuy = [];
    int currentMoney = totalBudget;

    // A. Beli yang Wajib (Must)
    for (var item in masterItems) {
      if (item['category'] == 'must') {
        if (currentMoney >= item['price']) {
          itemsToBuy.add(item);
          currentMoney -= item['price'] as int;
        }
      }
    }

    // B. Beli Tambahan (Allow) - Sisakan uang pegangan dikit (15rb)
    int bufferCash = 15000;

    for (var item in masterItems) {
      if (item['category'] == 'allow') {
        // Cek apakah uang cukup
        if (currentMoney - (item['price'] as int) >= bufferCash) {
          itemsToBuy.add(item);
          currentMoney -= item['price'] as int;
        }
      }
    }

    // 3. IDENTIFIKASI "JANGAN DULU"
    List<Map<String, dynamic>> finalItemsToSave = [];

    // Masukkan yang terbeli
    finalItemsToSave.addAll(itemsToBuy);

    // Cari yang TIDAK terbeli
    for (var masterItem in masterItems) {
      // Cek apakah ada di list terbeli?
      bool isBought = itemsToBuy.any((bought) => bought['name'] == masterItem['name']);

      if (!isBought) {
        // Jika tidak terbeli, simpan sebagai 'ignore'
        finalItemsToSave.add({
          'name': masterItem['name'],
          'price': masterItem['price'],
          'category': 'ignore',
        });
      }
    }

    // 4. SIMPAN KE DATABASE
    int budgetId = await DatabaseHelper.instance.createBudget(totalBudget, currentMoney);
    await DatabaseHelper.instance.insertShoppingItems(budgetId, finalItemsToSave);

    setState(() => isProcessing = false);

    // 5. NAVIGASI
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KosLifeHasilPage(budgetId: budgetId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Setup Belanjamu", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkNavy)),
            const SizedBox(height: 6),
            const Text("Atur budget makanan kamu di sini", style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 30),

            _buildLabel("Berapa Uang Makanmu?"),
            Container(
              decoration: BoxDecoration(
                color: cardSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy),
                inputFormatters: [CurrencyInputFormatter()],
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  prefixStyle: const TextStyle(color: primaryOrange, fontWeight: FontWeight.bold),
                  hintText: "Contoh: 150.000",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("Untuk Berapa Orang?"),
            _buildInputField(_peopleController, TextInputType.number),
            const SizedBox(height: 20),

            _buildLabel("Kondisi Khusus?"),
            Row(
                children: [
                  Expanded(child: _buildSelectableButton("Ada", _selectedCondition == "ada", () => setState(() => _selectedCondition = "ada"))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSelectableButton("Tidak Ada", _selectedCondition == "tidak ada", () => setState(() => _selectedCondition = "tidak ada")))
                ]
            ),
            const SizedBox(height: 20),

            _buildLabel("Kondisi Saat Ini?"),
            Row(
                children: [
                  Expanded(child: _buildSelectableButton("UTS/UAS", _selectedContext == "UTS/UAS", () => setState(() => _selectedContext = "UTS/UAS"))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSelectableButton("Tanggal Tua", _selectedContext == "tanggal tua", () => setState(() => _selectedContext = "tanggal tua")))
                ]
            ),
            const SizedBox(height: 12),
            Row(
                children: [
                  Expanded(child: _buildSelectableButton("Normal", _selectedContext == "normal", () => setState(() => _selectedContext = "normal"))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSelectableButton("Lagi Hemat", _selectedContext == "lagi hemat", () => setState(() => _selectedContext = "lagi hemat")))
                ]
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: isProcessing ? null : _processAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: isProcessing
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.auto_awesome, size: 20),
                      SizedBox(width: 8),
                      Text('Hitung Belanjaan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    ]
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: darkNavy))
  );

  Widget _buildInputField(TextEditingController controller, TextInputType type) {
    return Container(
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
            controller: controller,
            keyboardType: type,
            style: const TextStyle(color: darkNavy, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
            )
        )
    );
  }

  Widget _buildSelectableButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? primaryOrange : cardSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text(
                    text,
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13
                    )
                )
            )
        )
    );
  }
}

// FORMATTER RUPIAH
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) return newValue;
    int value = int.parse(newValue.text.replaceAll(RegExp('[^0-9]'), ''));
    String newText = CurrencyFormat.convertToIdr(value, 0).replaceAll('Rp ', '');
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
