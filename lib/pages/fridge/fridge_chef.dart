import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'recipe_detail.dart';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class FridgeChefPage extends StatefulWidget {
  const FridgeChefPage({Key? key}) : super(key: key);

  @override
  State<FridgeChefPage> createState() => _FridgeChefPageState();
}

class _FridgeChefPageState extends State<FridgeChefPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _capturedImage;
  bool _isScanning = false;
  bool _ingredientsDetected = false;
  bool _recipesGenerated = false;

  final List<String> _detectedIngredients = ['Brokoli', 'Ayam', 'Telur', 'Tomat', 'Wortel', 'Kecap', 'Bawang'];

  final List<Map<String, dynamic>> _recipes = [
    {
      "title": "Tumis Brokoli Ayam",
      "time": "20 menit",
      "difficulty": "Mudah",
      "rating": "4.8",
      "cal": "320 kal",
      "protein": "28 g",
      "tags": ["Brokoli", "Dada ayam", "+ 1 Lagi"],
      "ingredients": ["Brokoli (1 bonggol)", "Dada Ayam (200g)", "Bawang Putih (3 siung)", "Kecap Asin (2 sdm)", "Minyak Wijen (1 sdt)", "Garam & Lada"],
      "steps": ["Panaskan minyak di wajan.", "Tumis bawang putih hingga harum.", "Masukkan potongan dada ayam, masak hingga berubah warna.", "Tambahkan brokoli dan sedikit air.", "Masukkan kecap dan bumbu, masak hingga matang."],
      "videoPath": "lib/assets/videos/tutorial_brokoli.mp4"
    },
    {
      "title": "Salad Telur Avocado",
      "time": "15 menit",
      "difficulty": "Mudah",
      "rating": "4.6",
      "cal": "280 kal",
      "protein": "28 g",
      "tags": ["Telur", "Alpukat", "+ 1 Lagi"],
      "ingredients": ["Telur Rebus (2 butir)", "Alpukat Matang (1 buah)", "Tomat Cherry (5 buah)", "Selada (secukupnya)", "Lemon dressing"],
      "steps": ["Potong dadu alpukat dan telur rebus.", "Siapkan mangkuk, masukkan selada dan tomat.", "Campurkan semua bahan.", "Siram dengan dressing lemon dan lada hitam.", "Siap disajikan."],
      "videoPath": "lib/assets/videos/tutorial_salad.mp4"
    }
  ];

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, imageQuality: 80);
      if (photo != null) {
        setState(() {
          _capturedImage = photo; _isScanning = true; _ingredientsDetected = false; _recipesGenerated = false;
        });
        _simulateAIScan();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal membuka kamera: $e")));
    }
  }

  Future<void> _simulateAIScan() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() { _isScanning = false; _ingredientsDetected = true; });
  }

  void _generateRecipes() {
    setState(() => _isScanning = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() { _isScanning = false; _recipesGenerated = true; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PERBAIKAN DI SINI: Menambahkan jarak atas agar sama dengan KosLife AI
              const SizedBox(height: 20),

              _buildHeader(),
              const SizedBox(height: 30),

              if (_isScanning)
                _buildLoadingScanState()
              else if (!_ingredientsDetected)
                Column(
                  children: [
                    _buildInitialCameraState(),
                    const SizedBox(height: 30),
                    const Align(alignment: Alignment.centerLeft, child: Text("Menu Populer Hari Ini", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy))),
                    const SizedBox(height: 16),
                    _buildRecipeList(),
                  ],
                )
              else if (_ingredientsDetected && !_recipesGenerated)
                  _buildIngredientsFoundState()
                else
                  _buildFinalResultState(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
        child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.soup_kitchen, size: 36, color: primaryOrange),
                    SizedBox(width: 12),
                    Text('Fridge Chef', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: darkNavy))
                  ]
              ),
              const SizedBox(height: 8),
              const Text('Menu Sehat instan dari isi kulkasmu', style: TextStyle(fontSize: 14, color: Colors.grey))
            ]
        )
    );
  }

  Widget _buildInitialCameraState() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Column(children: [
        const Text("Apa yang ada di kulkasmu?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkNavy)),
        const SizedBox(height: 16),
        SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
                onPressed: _pickImageFromCamera,
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Foto isi kulkas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    ]
                )
            )
        ),
        const SizedBox(height: 12),
        const Text("AI akan mengenali bahan dan rekomendasi menu sehat", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ]),
    );
  }

  Widget _buildLoadingScanState() {
    return Center(child: Column(children: [
      if (_capturedImage != null) ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(_capturedImage!.path), height: 150, width: 150, fit: BoxFit.cover)),
      const SizedBox(height: 20), const CircularProgressIndicator(color: primaryOrange), const SizedBox(height: 16), const Text("AI sedang memindai kulkasmu...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: darkNavy)),
    ]));
  }

  Widget _buildIngredientsFoundState() {
    return Column(children: [
      _buildDetectedIngredientsCard(), const SizedBox(height: 24),
      SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _generateRecipes, style: ElevatedButton.styleFrom(backgroundColor: primaryOrange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.auto_awesome, size: 20), SizedBox(width: 8), Text('Generate Menu Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]))),
      const SizedBox(height: 16), TextButton.icon(onPressed: (){ setState(() { _ingredientsDetected = false; _capturedImage = null; }); }, icon: const Icon(Icons.refresh, color: Colors.grey), label: const Text("Foto Ulang", style: TextStyle(color: Colors.grey)))
    ]);
  }

  Widget _buildFinalResultState() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildDetectedIngredientsCard(), const SizedBox(height: 24),
      const Text("Rekomendasi Menu Sehat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
      const SizedBox(height: 16),
      _buildRecipeList(),
    ]);
  }

  Widget _buildRecipeList() {
    return Column(
      children: _recipes.map((recipe) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildRecipeCard(recipe),
        );
      }).toList(),
    );
  }

  Widget _buildDetectedIngredientsCard() {
    return Container(
        width: double.infinity, padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200)
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: const [
            Icon(Icons.check_circle, color: primaryOrange, size: 20),
            SizedBox(width: 8),
            Text("Bahan Terdeteksi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkNavy))
          ]),
          const SizedBox(height: 16),
          Wrap(
              spacing: 8, runSpacing: 8,
              children: _detectedIngredients.map((ingredient) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300)
                  ),
                  child: Text(ingredient, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: darkNavy))
              )).toList()
          )
        ])
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))]
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(recipe['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.access_time, size: 14, color: Colors.grey), const SizedBox(width: 4), Text("${recipe['time']}  ·  ${recipe['difficulty']}", style: const TextStyle(fontSize: 12, color: Colors.grey))])
          ]),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryOrange.withOpacity(0.5))),
              child: Row(children: [const Icon(Icons.star, size: 14, color: primaryOrange), const SizedBox(width: 2), Text(recipe['rating'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: darkNavy))])
          )
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                const Text("Kalori", style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(recipe['cal'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryOrange))
              ])
          )),
          const SizedBox(width: 12),
          Expanded(child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                const Text("Protein", style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(recipe['protein'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkNavy))
              ])
          )),
        ]),
        const SizedBox(height: 16),
        Wrap(spacing: 8, children: (recipe['tags'] as List<String>).map((tag) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)), child: Text(tag, style: const TextStyle(fontSize: 12, color: Colors.grey)))).toList()),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, height: 45, child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailPage(recipeData: recipe)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text("Lihat resep", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 18, color: Colors.white)]))),
      ]),
    );
  }
}
