import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'kos_life_hasil.dart';
import '../../../kos_life_utils.dart';

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
  final TextEditingController _peopleController = TextEditingController(text: '1');
  bool isProcessing = false;
  String _selectedContext = 'normal';

  @override
  void dispose() {
    _budgetController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  KondisiSaatIni _mapContextToEnum() {
    switch (_selectedContext) {
      case 'UTS/UAS': return KondisiSaatIni.utsUas;
      case 'tanggal tua': return KondisiSaatIni.tanggalTua;
      case 'lagi hemat': return KondisiSaatIni.lagiHemat;
      default: return KondisiSaatIni.normal;
    }
  }

  Future<void> _processAndNavigate() async {
    if (_budgetController.text.isEmpty) return;

    final int totalBudget = CurrencyFormat.parseIdr(_budgetController.text);
    if (totalBudget < 50000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Minimal budget Rp 50.000 ya')));
      return;
    }

    setState(() => isProcessing = true);

    try {
      final result = KosLifeDecisionEngine.generatePlan(totalBudget, _mapContextToEnum());

      final budgetResponse = await Supabase.instance.client
          .from('kos_life_budgets')
          .insert({
        'total_budget': totalBudget,
        'remaining_budget': result['remaining'],
        'smart_tip': result['smartTip'],
      })
          .select()
          .single();

      final int budgetId = budgetResponse['id'];

      final List<Map<String, dynamic>> itemsToInsert = (result['items'] as List).map((item) {
        return {
          'budget_id': budgetId,
          'name': item['name'],
          'price': item['price'],
          'category': item['category'],
        };
      }).toList();

      await Supabase.instance.client.from('kos_life_items').insert(itemsToInsert);

      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => KosLifeHasilPage(budgetId: budgetId)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Navigator.canPop(context) ? Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.pop(context),
              child: const Icon(
                  Icons.arrow_back,
                  color: darkNavy,
                  size: 20
              ),
            ),
          ),
        ) : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Setup Belanjamu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkNavy)
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: isProcessing
                    ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
                    : const Text(
                    'Hitung Belanjaan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: darkNavy))
  );

  Widget _buildCurrencyField() => TextField(
    controller: _budgetController,
    keyboardType: TextInputType.number,
    inputFormatters: [CurrencyInputFormatter()],
    style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy),
    decoration: InputDecoration(
        prefixText: 'Rp ',
        filled: true,
        fillColor: cardSurface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)
    ),
  );

  Widget _buildInputField(TextEditingController controller) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy),
    decoration: InputDecoration(
        filled: true,
        fillColor: cardSurface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)
    ),
  );

  Widget _buildContextButtons() => Column(
    children: [
      Row(children: [_contextBtn('UTS/UAS'), const SizedBox(width: 12), _contextBtn('tanggal tua')]),
      const SizedBox(height: 12),
      Row(children: [_contextBtn('normal'), const SizedBox(width: 12), _contextBtn('lagi hemat')]),
    ],
  );

  Widget _contextBtn(String label) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => _selectedContext = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
            color: _selectedContext == label ? primaryOrange : cardSurface,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Center(
            child: Text(
                label,
                style: TextStyle(
                    color: _selectedContext == label ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.bold
                )
            )
        ),
      ),
    ),
  );
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) return const TextEditingValue();
    final value = int.parse(cleanText);
    final newText = CurrencyFormat.convertToIdr(value, 0).replaceAll('Rp ', '');
    return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}
