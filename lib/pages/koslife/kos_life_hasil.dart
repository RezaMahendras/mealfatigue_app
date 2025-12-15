import 'package:flutter/material.dart';
import '../../database_helper.dart';
import '../../kos_life_utils.dart';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class KosLifeHasilPage extends StatefulWidget {
  final int budgetId;

  const KosLifeHasilPage({Key? key, required this.budgetId}) : super(key: key);

  @override
  State<KosLifeHasilPage> createState() => _KosLifeHasilPageState();
}

class _KosLifeHasilPageState extends State<KosLifeHasilPage> {
  List<Map<String, dynamic>> mustItems = [];
  List<Map<String, dynamic>> allowItems = [];

  int totalBudget = 0;
  int remainingBudget = 0;
  String smartTip = '';

  bool isLoading = true;
  bool showDetails = true;

  @override
  void initState() {
    super.initState();
    _fetchResultData();
  }

  Future<void> _fetchResultData() async {
    final budgetData =
    await DatabaseHelper.instance.getBudgetById(widget.budgetId);
    final items =
    await DatabaseHelper.instance.getItemsByBudget(widget.budgetId);

    setState(() {
      if (budgetData != null) {
        totalBudget = budgetData['total_budget'];
        remainingBudget = budgetData['remaining_budget'];
        smartTip = budgetData['smart_tip'] ?? '';
      }

      mustItems = items.where((i) => i['category'] == 'must').toList();
      allowItems = items.where((i) => i['category'] == 'allow').toList();

      isLoading = false;
    });
  }

  void _backToMain() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final int totalMust =
    mustItems.fold(0, (sum, i) => sum + (i['price'] as int));
    final int totalAllow =
    allowItems.fold(0, (sum, i) => sum + (i['price'] as int));
    final int estimasiTotal = totalMust + totalAllow;

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
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator(color: primaryOrange))
          : SingleChildScrollView(
        padding:
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(estimasiTotal),
            const SizedBox(height: 24),

            if (showDetails) ...[
              if (mustItems.isNotEmpty)
                _buildCategoryCard(
                  title: 'Harus Beli',
                  items: mustItems,
                  color: primaryOrange,
                ),
              if (mustItems.isNotEmpty)
                const SizedBox(height: 16),

              if (allowItems.isNotEmpty)
                _buildCategoryCard(
                  title: 'Boleh Beli',
                  items: allowItems,
                  color: darkNavy,
                ),
              const SizedBox(height: 24),

              _buildSmartTip(),
            ],

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _backToMain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
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
  Widget _buildSummaryCard(int estimasiTotal) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimasi Total Belanja',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              IconButton(
                icon: Icon(
                    showDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey),
                onPressed: () =>
                    setState(() => showDetails = !showDetails),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            CurrencyFormat.convertToIdr(estimasiTotal, 0),
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryOrange),
          ),
          const SizedBox(height: 6),
          Text(
            'Sisa Uang Cash: ${CurrencyFormat.convertToIdr(remainingBudget, 0)}',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: darkNavy),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required List<Map<String, dynamic>> items,
    required Color color,
  }) {
    final total = items.fold(0, (sum, i) => sum + (i['price'] as int));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(CurrencyFormat.convertToIdr(total, 0),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(item['name'],
                            style: const TextStyle(fontSize: 14)),
                      ),
                      Text(
                        CurrencyFormat.convertToIdr(item['price'], 0),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Smart Tip',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryOrange)),
          const SizedBox(height: 6),
          Text(
            smartTip.isNotEmpty
                ? smartTip
                : 'Atur belanja sesuai kondisi agar keuangan tetap aman.',
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
