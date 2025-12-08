import 'package:flutter/material.dart';

// --- Definisi Warna ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

// --- Model Data FAQ ---
class FaqItem {
  final String question;
  final String answer;
  final String category; // 'General', 'Account', 'Payment', 'Security'

  FaqItem({required this.question, required this.answer, required this.category});
}

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({Key? key}) : super(key: key);

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  // Controller untuk search bar
  final TextEditingController _searchController = TextEditingController();

  // State untuk kategori yang dipilih
  String _selectedCategory = 'All';

  // Database Dummy Pertanyaan
  final List<FaqItem> _allFaqs = [
    FaqItem(
      category: 'Account',
      question: "Bagaimana cara mengubah profil?",
      answer: "Anda dapat mengubah profil dengan menekan ikon edit (pensil) pada foto profil di halaman utama profil, atau melalui menu 'Account Info'.",
    ),
    FaqItem(
      category: 'Security',
      question: "Bagaimana cara mereset password?",
      answer: "Masuk ke menu Security & Privacy, lalu pilih opsi 'Change Password'. Link reset akan dikirim ke email Anda.",
    ),
    FaqItem(
      category: 'Security',
      question: "Apakah data kesehatan saya aman?",
      answer: "Ya, kami menggunakan enkripsi standar industri (AES-256) untuk menjaga keamanan data pribadi dan kesehatan Anda.",
    ),
    FaqItem(
      category: 'Payment',
      question: "Metode pembayaran apa yang tersedia?",
      answer: "Saat ini kami mendukung Kartu Kredit, Transfer Bank (Virtual Account), dan E-Wallet (GoPay, OVO, Dana).",
    ),
    FaqItem(
      category: 'General',
      question: "Bagaimana cara menghubungi CS?",
      answer: "Anda bisa menggunakan fitur Live Chat di bawah ini atau mengirim email ke support@mealapp.com.",
    ),
  ];

  // List yang akan ditampilkan (hasil filter)
  List<FaqItem> _filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqs = _allFaqs; // Awalnya tampilkan semua
  }

  // --- Logic Filtering (Search + Category) ---
  void _runFilter() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      _filteredFaqs = _allFaqs.where((item) {
        // 1. Cek Kategori
        bool matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;

        // 2. Cek Search Text
        bool matchesSearch = item.question.toLowerCase().contains(query) ||
            item.answer.toLowerCase().contains(query);

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _runFilter(); // Jalankan filter ulang saat kategori berubah
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: darkNavy, size: 20),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          "Help Center",
          style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // --- HEADER SECTION (Statis) ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "How can we help you?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkNavy),
                ),
                const SizedBox(height: 8),
                Text(
                  "Find answers or contact support.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                // SEARCH BAR
                Container(
                  decoration: BoxDecoration(
                    color: cardSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _runFilter(), // Auto search saat ngetik
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _runFilter();
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      hintText: "Search topics...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // CATEGORY TABS (Scrollable Horizontal)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('All'),
                      _buildCategoryChip('Account'),
                      _buildCategoryChip('Security'),
                      _buildCategoryChip('Payment'),
                      _buildCategoryChip('General'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // --- SCROLLABLE CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Frequently Asked Questions",
                    style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // HASIL PENCARIAN / LIST FAQ
                  if (_filteredFaqs.isEmpty)
                    _buildEmptyState()
                  else
                    ..._filteredFaqs.map((item) => _buildFaqItem(item)).toList(),

                  const SizedBox(height: 32),

                  // CONTACT SUPPORT
                  const Text(
                    "Still need help?",
                    style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                      Icons.email_outlined,
                      "Email Support",
                      "Get response within 24h",
                          () {
                        // Simulasi aksi email
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Opening Email App...")),
                        );
                      }
                  ),
                  const SizedBox(height: 12),
                  _buildContactItem(
                      Icons.chat_bubble_outline,
                      "Live Chat",
                      "Available 09:00 - 17:00",
                          () {
                        // Simulasi aksi chat
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Connecting to Live Agent...")),
                        );
                      }
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget: Chips Kategori (Pill Shape)
  Widget _buildCategoryChip(String title) {
    bool isSelected = _selectedCategory == title;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => _onCategorySelected(title),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? darkNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? darkNavy : Colors.grey.shade300,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // Widget: FAQ Item Expansion Tile
  Widget _buildFaqItem(FaqItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        // Menghilangkan garis border bawaan ExpansionTile saat dibuka
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: primaryOrange,
          collapsedIconColor: Colors.grey,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            item.question,
            style: const TextStyle(fontWeight: FontWeight.w600, color: darkNavy, fontSize: 14),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Garis vertikal kecil sebagai penanda visual
                  Container(width: 2, height: 40, color: primaryOrange.withOpacity(0.3)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.answer,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Empty State (Jika tidak ada hasil search)
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              "Oops, not found.",
              style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Try searching for another keyword.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Contact Button yang bisa diklik
  Widget _buildContactItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryOrange, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
