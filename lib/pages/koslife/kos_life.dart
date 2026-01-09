import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'kos_life_setup.dart';
import '../../kos_life_utils.dart';

const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class KosLifePage extends StatefulWidget {
  const KosLifePage({Key? key}) : super(key: key);

  @override
  State<KosLifePage> createState() => _KosLifePageState();
}

class _KosLifePageState extends State<KosLifePage> {
  int totalBudget = 0;
  int terpakai = 0;
  String smartTip = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => isLoading = true);

      final data = await Supabase.instance.client
          .from('kos_life_budgets')
          .select()
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data != null) {
        setState(() {
          totalBudget = data['total_budget'] ?? 0;
          terpakai = totalBudget - (data['remaining_budget'] as int);
          smartTip = data['smart_tip'] ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading budget: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _onNavigateBack() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final int sisa = totalBudget - terpakai;
    final double progress = totalBudget == 0 ? 0 : (terpakai / totalBudget).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryOrange))
          : SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_cart, size: 36, color: primaryOrange),
                    SizedBox(width: 12),
                    Text('KosLife AI', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: darkNavy, letterSpacing: -0.5)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Solusi cerdas untuk mengatur belanja makanan sesuai kondisi dan budget kamu', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4)),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Budget Terakhir', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(CurrencyFormat.convertToIdr(totalBudget, 0), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: darkNavy)),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Terpakai (Plan)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: darkNavy)),
                                Text(CurrencyFormat.convertToIdr(terpakai, 0), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryOrange)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: const AlwaysStoppedAnimation<Color>(primaryOrange),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Sisa (Tabung)', style: TextStyle(fontSize: 14, color: Colors.grey)),
                                Text(CurrencyFormat.convertToIdr(sisa, 0), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: darkNavy)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (smartTip.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: primaryOrange.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                          child: Text(smartTip, style: const TextStyle(fontSize: 12, color: darkNavy, height: 1.4), textAlign: TextAlign.center),
                        ),
                      ],
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const KosLifeSetupPage())).then((_) => _onNavigateBack());
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: primaryOrange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.auto_awesome, size: 20),
                              const SizedBox(width: 8),
                              Text(totalBudget == 0 ? 'Buat Budget Baru' : 'Edit / Buat Baru', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
