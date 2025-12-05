import 'package:flutter/material.dart';
import 'kos_life_setup.dart';
import '../../database_helper.dart';
import '../../kos_life_utils.dart';

// --- Definisi Warna Tema (Konsisten dengan Home) ---
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getLastBudget();
    if (data != null) {
      setState(() {
        totalBudget = data['total_budget'];
        terpakai = totalBudget - (data['remaining_budget'] as int);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onNavigateBack() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    int sisa = totalBudget - terpakai;
    double progress = totalBudget == 0 ? 0 : terpakai / totalBudget;

    return Scaffold(
      backgroundColor: Colors.white, // UBAH: Latar Putih
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryOrange))
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // UBAH: Icon warna Oranye
                  Icon(Icons.shopping_cart, size: 36, color: primaryOrange),
                  SizedBox(width: 12),
                  // UBAH: Teks warna Navy
                  Text(
                      'KosLife AI',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: darkNavy, letterSpacing: -0.5)
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Main Card Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    // UBAH: Border tipis & Shadow halus (Style Dashboard)
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'Budget Bulan Ini',
                        style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600)
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyFormat.convertToIdr(totalBudget, 0),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: darkNavy),
                    ),
                    const SizedBox(height: 24),

                    // Inner Stats Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        // UBAH: Warna latar cool grey (bukan peach lagi)
                        color: cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        // Tidak perlu shadow dalam, cukup warna solid
                      ),
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

                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: Colors.grey.shade300,
                                // UBAH: Warna progress Oranye
                                valueColor: const AlwaysStoppedAnimation<Color>(primaryOrange)
                            ),
                          ),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Sisa (Tabung)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                              Text(CurrencyFormat.convertToIdr(sisa, 0), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: darkNavy)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const KosLifeSetupPage())).then((_) => _onNavigateBack());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryOrange, // UBAH: Warna Oranye
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0, // Flat design lebih modern
                            // Shadow halus jika ingin
                            shadowColor: primaryOrange.withOpacity(0.4)
                        ),
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
                    const SizedBox(height: 16),
                    const Center(child: Text('AI akan buatkan daftar belanja sesuai budget kamu', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
