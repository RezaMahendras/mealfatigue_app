import 'package:flutter/material.dart';
import '../dharmony/weekend_cooking_mode.dart';

const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);
const Color textGrey = Color(0xFF64748B);

class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  const RecipeDetailPage({Key? key, required this.recipeData}) : super(key: key);

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    recipeData['title'] ?? 'Recipe',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: darkNavy)
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                        "${recipeData['time'] ?? '-'} • ${recipeData['difficulty'] ?? 'Easy'}",
                        style: const TextStyle(color: textGrey, fontWeight: FontWeight.w500)
                    ),
                    const Spacer(),
                    const Icon(Icons.star, size: 16, color: primaryOrange),
                    const SizedBox(width: 4),
                    Text(
                        recipeData['rating']?.toString() ?? '4.5',
                        style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Row(
                  children: [
                    _buildNutriBox("Kalori", recipeData['calories']?.toString() ?? recipeData['cal']?.toString() ?? '-', primaryOrange),
                    const SizedBox(width: 16),
                    _buildNutriBox("Protein", recipeData['protein']?.toString() ?? '-', darkNavy),
                  ],
                ),
                const SizedBox(height: 30),
                _buildCardSection("Bahan-bahan", (recipeData['ingredients'] as List?)?.map((e) => e.toString()).toList() ?? []),
                const SizedBox(height: 24),
                _buildStepsSection("Cara Memasak", recipeData['steps'] as List? ?? []),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeekendCookingModePage(
                            recipeTitle: recipeData['title'] ?? 'Cooking',
                            recipeSteps: recipeData['steps'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                        "Mulai Memasak!",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutriBox(String label, String val, Color col) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: textGrey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: col)),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(String title, List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
          const SizedBox(height: 16),
          ...items.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 16, color: primaryOrange),
                const SizedBox(width: 12),
                Expanded(child: Text(e, style: const TextStyle(fontSize: 14, color: darkNavy))),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildStepsSection(String title, List steps) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            var step = entry.value;
            String desc = (step is Map) ? (step['description'] ?? '') : step.toString();
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${entry.key + 1}. ",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: primaryOrange, fontSize: 15)
                  ),
                  Expanded(
                      child: Text(
                          desc,
                          style: const TextStyle(height: 1.5, fontSize: 14, color: darkNavy)
                      )
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
