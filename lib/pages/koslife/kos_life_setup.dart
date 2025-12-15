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
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _peopleController =
  TextEditingController(text: '1');

  bool isProcessing = false;

  // UI STATE
  String _selectedCondition = 'tidak ada';
  String _selectedContext = 'normal';

  @override
  void dispose() {
    _budgetController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  /// ===============================
  /// MAPPING STRING → ENUM (PENTING)
  /// ===============================
  KondisiSaatIni _mapContextToEnum() {
    switch (_selectedContext) {
      case 'UTS/UAS':
        return KondisiSaatIni.utsUas;
      case 'tanggal tua':
        return KondisiSaatIni.tanggalTua;
      case 'lagi hemat':
        return KondisiSaatIni.lagiHemat;
      default:
        return KondisiSaatIni.normal;
    }
  }

  /// ===============================
  /// PROSES & NAVIGASI (BERSIH)
  /// ===============================
  Future<void> _processAndNavigate() async {
    final int totalBudget =
    CurrencyFormat.parseIdr(_budgetController.text);

    if (totalBudget < 50000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal budget Rp 50.000 ya')),
      );
      return;
    }

    setState(() => isProcessing = true);

    // 🔑 INI SATU-SATUNYA TEMPAT HITUNG BELANJA
    final result = KosLifeDecisionEngine.generatePlan(
      totalBudget,
      _mapContextToEnum(),
    );

    // Simpan ke database
    final int budgetId = await DatabaseHelper.instance.createBudget(
      totalBudget,
      result['remaining'],
      result['smartTip'],
    );


    await DatabaseHelper.instance.insertShoppingItems(
      budgetId,
      result['items'],
    );

    setState(() => isProcessing = false);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KosLifeHasilPage(budgetId: budgetId),
      ),
    );
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Setup Belanjamu',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkNavy),
            ),
            const SizedBox(height: 6),
            const Text(
              'Atur budget makanan kamu di sini',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            _buildLabel('Berapa Uang Makanmu?'),
            _buildCurrencyField(),
            const SizedBox(height: 20),

            _buildLabel('Untuk Berapa Orang?'),
            _buildInputField(_peopleController),
            const SizedBox(height: 20),

            _buildLabel('Kondisi Saat Ini?'),
            _buildContextButtons(),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isProcessing ? null : _processAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.auto_awesome, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Hitung Belanjaan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                    )
                      ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// UI COMPONENTS
  /// ===============================
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: darkNavy),
    ),
  );

  Widget _buildCurrencyField() => TextField(
  controller: _budgetController,
  keyboardType: TextInputType.number,
  inputFormatters: [CurrencyInputFormatter()],
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: darkNavy,
  ),
  decoration: InputDecoration(
    prefixText: 'Rp ',
    prefixStyle: const TextStyle(
      color: primaryOrange,
      fontWeight: FontWeight.bold,
    ),
    hintText: 'Contoh: 150.000',
    hintStyle: TextStyle(color: Colors.grey),
    filled: true,
    fillColor: cardSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
);


  Widget _buildInputField(TextEditingController controller) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      filled: true,
      fillColor: cardSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _buildContextButtons() => Column(
    children: [
      Row(
        children: [
          _contextBtn('UTS/UAS'),
          const SizedBox(width: 12),
          _contextBtn('tanggal tua'),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          _contextBtn('normal'),
          const SizedBox(width: 12),
          _contextBtn('lagi hemat'),
        ],
      ),
    ],
  );

  Widget _contextBtn(String label) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => _selectedContext = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _selectedContext == label
              ? primaryOrange
              : cardSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: _selectedContext == label
                  ? Colors.white
                  : Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

/// ===============================
/// FORMATTER RUPIAH
/// ===============================
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final value =
    int.parse(newValue.text.replaceAll(RegExp('[^0-9]'), ''));
    final newText =
    CurrencyFormat.convertToIdr(value, 0).replaceAll('Rp ', '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
