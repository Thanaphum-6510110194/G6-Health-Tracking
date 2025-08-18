import 'package:flutter/material.dart';
import '../nutrition_api/nutrition_api.dart';

void main() {
  runApp(NutritionApp());
}

class NutritionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutritionix Example',
      home: NutritionScreen(),
    );
  }
}

class NutritionScreen extends StatefulWidget {
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _nutritionData;
  String _error = '';
  bool _loading = false;

  void _searchNutrition() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _error = '';
      _nutritionData = null;
    });

    try {
      final result = await fetchNutritionixData(query);
      setState(() {
        _nutritionData = result['foods'][0];
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildNutritionInfo() {
    if (_nutritionData == null) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🍽️ ${_nutritionData!['food_name']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text("🔥 Calories: ${_nutritionData!['nf_calories']} kcal"),
        Text("💪 Protein: ${_nutritionData!['nf_protein']} g"),
        Text("🍟 Fat: ${_nutritionData!['nf_total_fat']} g"),
        Text("🍞 Carbs: ${_nutritionData!['nf_total_carbohydrate']} g"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nutrition Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter food (e.g., 2 eggs and toast)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchNutrition(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchNutrition,
              child: Text('Search Nutrition'),
            ),
            SizedBox(height: 20),
            if (_loading) CircularProgressIndicator(),
            if (_error.isNotEmpty) Text("❌ $_error", style: TextStyle(color: Colors.red)),
            if (_nutritionData != null) _buildNutritionInfo(),
          ],
        ),
      ),
    );
  }
}
