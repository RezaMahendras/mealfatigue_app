import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'recipe_detail.dart';

const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);
const Color textGrey = Color(0xFF64748B);

class FridgeChefPage extends StatefulWidget {
  const FridgeChefPage({Key? key}) : super(key: key);

  @override
  State<FridgeChefPage> createState() => _FridgeChefPageState();
}

class _FridgeChefPageState extends State<FridgeChefPage> {
  final _supabase = Supabase.instance.client;
  List<String> _userIngredients = [];
  List<Map<String, dynamic>> _filteredRecipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final fridgeData = await _supabase.from('my_fridge').select();
      _userIngredients = List<String>.from(fridgeData.map((item) => item['ingredient_name']));

      if (_userIngredients.isNotEmpty) {
        final List<dynamic> response = await _supabase.rpc(
          'search_recipes_by_ingredients',
          params: {'search_ingredients': _userIngredients},
        );

        setState(() {
          _filteredRecipes = List<Map<String, dynamic>>.from(response);
        });
      } else {
        setState(() => _filteredRecipes = []);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              const SizedBox(height: 25),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.soup_kitchen, size: 36, color: primaryOrange),
                        SizedBox(width: 12),
                        Text(
                          'Fridge Chef',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: darkNavy,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Menu Sehat instan dari isi kulkasmu',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    const Text(
                      "Apa yang ada di kulkasmu?",
                      style: TextStyle(color: darkNavy, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => const IngredientInputPage()));
                          _loadData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryOrange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Kelola Isi Kulkas",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _userIngredients.isEmpty
                          ? "Belum ada bahan terdaftar"
                          : "Terdeteksi ${_userIngredients.length} bahan kulkas",
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                "Rekomendasi Menu Sehat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy),
              ),
              const SizedBox(height: 16),

              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: primaryOrange))
                  : _buildRecipeList(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeList() {
    if (_userIngredients.isEmpty || _filteredRecipes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            _userIngredients.isEmpty ? "Input bahan kulkas dulu ya!" : "Tidak ada resep yang cocok.",
            style: const TextStyle(color: textGrey),
          ),
        ),
      );
    }
    return Column(children: _filteredRecipes.map((r) => _buildModernRecipeCard(r)).toList());
  }

  Widget _buildModernRecipeCard(Map<String, dynamic> recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(recipe['title'] ?? 'Resep',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
              ),
              _buildRatingTag(recipe['rating']?.toString() ?? '4.6'),
            ],
          ),
          const SizedBox(height: 4),
          Text("${recipe['time'] ?? '20 m'}  •  Mudah", style: const TextStyle(fontSize: 12, color: textGrey)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildSmallNutri("Kalori", "${recipe['calories'] ?? '-'} kal", primaryOrange),
              const SizedBox(width: 12),
              _buildSmallNutri("Protein", "${recipe['protein'] ?? '-'} g", darkNavy),
            ],
          ),
          const SizedBox(height: 16),
          _buildSmallIngredientTags(recipe['ingredients'] as List? ?? []),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailPage(recipeData: recipe))),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                  "Lihat Resep",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    );
  }

  Widget _buildRatingTag(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(Icons.star, size: 12, color: primaryOrange),
          const SizedBox(width: 4),
          Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: darkNavy)),
        ],
      ),
    );
  }

  Widget _buildSmallNutri(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: textGrey)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallIngredientTags(List ingredients) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...ingredients.take(3).map((ing) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: cardSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Text(
              ing.toString(),
              style: const TextStyle(fontSize: 9, color: textGrey, fontWeight: FontWeight.w500)
          ),
        )).toList(),
        if (ingredients.length > 3)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
                "+${ingredients.length - 3} lagi",
                style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w500)
            ),
          ),
      ],
    );
  }
}

// --- HALAMAN INPUT BAHAN (DENGAN TOMBOL KEMBALI CUSTOM) ---
class IngredientInputPage extends StatefulWidget {
  const IngredientInputPage({Key? key}) : super(key: key);
  @override
  State<IngredientInputPage> createState() => _IngredientInputPageState();
}

class _IngredientInputPageState extends State<IngredientInputPage> {
  final _supabase = Supabase.instance.client;
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() { super.initState(); _fetch(); }

  Future<void> _fetch() async {
    final data = await _supabase.from('my_fridge').select().order('created_at', ascending: false);
    setState(() => _items = List<Map<String, dynamic>>.from(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
            "Kelola Isi Kulkas",
            style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 16)
        ),
        // --- PERBAIKAN TOMBOL KEMBALI DISINI ---
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(color: cardSurface, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: darkNavy, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: "Tambah bahan...",
                  hintStyle: const TextStyle(fontSize: 14, color: textGrey),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle, color: primaryOrange),
                    onPressed: () async {
                      if (_controller.text.isEmpty) return;
                      await _supabase.from('my_fridge').insert({'ingredient_name': _controller.text.trim()});
                      _controller.clear(); _fetch();
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text("Kulkas masih kosong", style: TextStyle(color: textGrey)))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _items.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.restaurant_menu, color: primaryOrange, size: 18),
                  title: Text(_items[index]['ingredient_name'], style: const TextStyle(fontWeight: FontWeight.bold, color: darkNavy, fontSize: 14)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: () async {
                      await _supabase.from('my_fridge').delete().eq('id', _items[index]['id']);
                      _fetch();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
