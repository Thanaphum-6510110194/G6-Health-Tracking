import 'package:flutter/material.dart';
import 'package:health_tracking/screens/dashboard.dart';

class TakePhotoScreen extends StatelessWidget {
  const TakePhotoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take Photo')),
      body: const Center(child: Text('Take Photo Screen Content')),
    );
  }
}

class SearchFoodScreen extends StatelessWidget {
  const SearchFoodScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Food')),
      body: const Center(child: Text('Search Food Screen Content')),
    );
  }
}

// --- Main Meal Logging Screen ---
class MealLoggingScreen extends StatefulWidget {
  const MealLoggingScreen({super.key});

  @override
  State<MealLoggingScreen> createState() => _MealLoggingScreenState();
}

class _MealLoggingScreenState extends State<MealLoggingScreen> {
  String _selectedMealType = 'Breakfast';

  static const Color _primaryColor = Color(0xFF0ABAB5);
  static const Color _secondaryColor = Color(0xFF56DFCF);
  static const Color _backgroundColor = Colors.white;
  static const Color _greyText = Color(0xFF616161);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Header Section ---
              _buildHeader(),
              const SizedBox(height: 25),

              // --- Meal Type Tabs ---
              _buildMealTypeTabs(),
              const SizedBox(height: 25),

              // --- Action Buttons (Take Photo & Search Food) ---
              _buildActionButtons(),
              const SizedBox(height: 25),

              // --- Today's Meals Section ---
              _buildTodaysMeals(),
              const SizedBox(height: 25),

              // --- Nutrition Summary Section ---
              _buildNutritionSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text(
          'Meal Logging',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Track your nutrition',
          style: TextStyle(fontSize: 16, color: _greyText),
        ),
      ],
    );
  }

  Widget _buildMealTypeTabs() {
    final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: mealTypes.map((type) {
          final bool isSelected = _selectedMealType == type;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMealType = type;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _secondaryColor.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? _primaryColor : _greyText,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildActionButton(
            label: 'Take Photo',
            subtitle: 'Scan your meal',
            icon: Icons.camera_alt,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TakePhotoScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildActionButton(
            label: 'Search Food',
            subtitle: 'Find in database',
            icon: Icons.search,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchFoodScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      color: _backgroundColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        overlayColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? _primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 40, color: _primaryColor),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: _greyText),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysMeals() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      color: _backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Today's Meals",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            _buildMealEntry(
              iconColor: const Color(0xFFF0E8D9),
              icon: Icons.fastfood,
              mealName: 'Pancakes with Syrup',
              details: '320 calories • 45g carbs',
            ),
            const Divider(height: 25, thickness: 0.5, color: Colors.grey),
            _buildMealEntry(
              iconColor: const Color(0xFFE6D9E8),
              icon: Icons.coffee,
              mealName: 'Coffee with Milk',
              details: '45 calories • 6g carbs',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealEntry({
    required Color iconColor,
    required IconData icon,
    required String mealName,
    required String details,
  }) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.brown[700], size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                mealName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                details,
                style: const TextStyle(fontSize: 14, color: _greyText),
              ),
            ],
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: _secondaryColor,
          ),
          onPressed: () {
            print('Edit $mealName');
          },
          child: const Text('Edit', style: TextStyle(color: _primaryColor)),
        ),
      ],
    );
  }

  Widget _buildNutritionSummary() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      color: _backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Nutrition Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildSummaryItem(
                  value: '365',
                  unit: 'calories',
                  color: _primaryColor,
                ),
                _buildSummaryItem(
                  value: '51g',
                  unit: 'protein',
                  color: Colors.orange,
                ),
                _buildSummaryItem(
                  value: '12g',
                  unit: 'carbs',
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(unit, style: const TextStyle(fontSize: 14, color: _greyText)),
      ],
    );
  }
}
