import 'package:flutter/material.dart';
import '../../database_helper.dart'; // Sesuaikan path jika beda folder
import '../../kos_life_utils.dart'; // Sesuaikan path jika beda folder

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
  // --- STATE VARIABLES ---
  List<Map<String, dynamic>> mustItems = [];
  List<Map<String, dynamic>> allowItems = [];
  List<Map<String, dynamic>> ignoreItems = []; // List untuk barang 'Jangan Dulu'

  int totalBudget = 0;
  int remainingBudget = 0;
  bool isLoading = true;

  bool _showDetails = true;

  @override
  void initState() {
    super.initState();
    _fetchResultData();
  }

  // Mengambil data dari Database dan memilahnya
  Future<void> _fetchResultData() async {
    final budgetData = await DatabaseHelper.instance.getLastBudget();
    final items = await DatabaseHelper.instance.getItemsByBudget(widget.budgetId);

    setState(() {
      if (budgetData != null) {
        totalBudget = budgetData['total_budget'];
        remainingBudget = budgetData['remaining_budget'];
      }

      // Filter item berdasarkan kategori yang disimpan dari Setup Page
      mustItems = items.where((i) => i['category'] == 'must').toList();
      allowItems = items.where((i) => i['category'] == 'allow').toList();
      ignoreItems = items.where((i) => i['category'] == 'ignore').toList(); // Ambil yang ignore

      isLoading = false;
    });
  }

  // Fungsi tombol Selesai (Keluar dari flow KosLife)
  void _backToMain() {
    Navigator.of(context).pop(); // Tutup Hasil
    Navigator.of(context).pop(); // Tutup Setup
  }

  @override
  Widget build(BuildContext context) {
    // Hitung total per kategori untuk display di header card
    int totalMust = mustItems.fold(0, (sum, item) => sum + (item['price'] as int));
    int totalAllow = allowItems.fold(0, (sum, item) => sum + (item['price'] as int));
    int totalIgnore = ignoreItems.fold(0, (sum, item) => sum + (item['price'] as int));

    // Estimasi total hanya menghitung yang DIBELI (Must + Allow)
    int estimasiTotal = totalMust + totalAllow;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // --- CARD UTAMA: ESTIMASI TOTAL ---
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Estimasi Total Belanja", style: TextStyle(fontSize: 14, color: Colors.grey)),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _showDetails = !_showDetails;
                                  });
                                },
                                child: Icon(
                                    _showDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    color: Colors.grey, size: 24
                                ),
                              )
                            ]
                        ),
                        const SizedBox(height: 4),
                        Text(
                            CurrencyFormat.convertToIdr(estimasiTotal, 0),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryOrange)
                        ),
                        const SizedBox(height: 8),
                        // Info Sisa Uang Cash (Uang Pegangan)
                        Text(
                            "Sisa Uang Cash: ${CurrencyFormat.convertToIdr(remainingBudget, 0)}",
                            style: const TextStyle(fontSize: 12, color: darkNavy, fontWeight: FontWeight.w600)
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- LIST ITEM ---
                  if (_showDetails) ...[

                    // 1. KATEGORI: HARUS BELI (ORANGE)
                    if (mustItems.isNotEmpty)
                      _buildCategoryCard(
                          title: "Harus Beli",
                          totalPrice: CurrencyFormat.convertToIdr(totalMust, 0),
                          headerColor: primaryOrange,
                          headerTextColor: Colors.white,
                          items: mustItems
                      ),

                    if (mustItems.isNotEmpty) const SizedBox(height: 16),

                    // 2. KATEGORI: BOLEH BELI (NAVY)
                    if (allowItems.isNotEmpty)
                      _buildCategoryCard(
                          title: "Boleh Beli",
                          totalPrice: CurrencyFormat.convertToIdr(totalAllow, 0),
                          headerColor: darkNavy,
                          headerTextColor: Colors.white,
                          items: allowItems
                      ),

                    if (allowItems.isNotEmpty) const SizedBox(height: 16),

                    // 3. KATEGORI: JANGAN DULU / DITUNDA (GREY)
                    // Ini yang kamu minta: Dibuatkan list bahan-bahannya juga
                    if (ignoreItems.isNotEmpty)
                      _buildCategoryCard(
                          title: "Jangan Dulu (Ditunda)",
                          totalPrice: CurrencyFormat.convertToIdr(totalIgnore, 0),
                          headerColor: Colors.grey.shade400, // Warna Abu biar beda
                          headerTextColor: Colors.white,
                          items: ignoreItems // Menggunakan list item ignore
                      ),

                    const SizedBox(height: 24),

                    // --- SMART TIP ---
                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryOrange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Smart Tip", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryOrange)),
                            const SizedBox(height: 6),
                            Text(
                                ignoreItems.isNotEmpty
                                    ? "Ada ${ignoreItems.length} barang yang ditunda karena melebihi budget. Prioritaskan kebutuhan pokok dulu ya!"
                                    : "Hebat! Budgetmu cukup untuk membeli semua kebutuhanmu.",
                                style: const TextStyle(fontSize: 13, color: darkNavy, height: 1.4)
                            )
                          ]
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),

              // --- TOMBOL SELESAI ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _backToMain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Selesai', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER UNTUK MEMBUAT LIST ---
  Widget _buildCategoryCard({
    required String title,
    required String totalPrice,
    required Color headerColor,
    required Color headerTextColor,
    required List<Map<String, dynamic>> items
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
      ),
      child: Column(
        children: [
          // Header Card (Judul & Total Harga Kategori)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12))
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: headerTextColor)),
                  Text(totalPrice, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: headerTextColor))
                ]
            ),
          ),
          // List Item (Nama Barang & Harga)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nama Barang (pakai Expanded biar gak overflow kalau panjang)
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Harga Barang
                      Text(
                          CurrencyFormat.convertToIdr(item['price'], 0),
                          style: const TextStyle(fontSize: 14, color: Color(0xFF4A4A4A))
                      )
                    ]
                ),
              );
            }).toList()),
          ),
        ],
      ),
    );
  }
}
