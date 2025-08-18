import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_notifier.dart';
import 'login_screen.dart';

const Color primaryColor = Color(0xFF0ABAB5);
const Color secondaryColor = Color(0xFF56DFCF);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();
    String name = auth.fullName ?? '';
    if (name.isEmpty) {
      auth.fetchUserData();
      name = auth.fullName ?? '';
    }
    final today = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context, name, today),
              const SizedBox(height: 15),
              _buildHealthMetricCard(context, auth),
              const SizedBox(height: 15),
              _buildProgressSection(),
              const SizedBox(height: 15),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String today) {
    final greeting = '${getGreeting()}${name.isNotEmpty ? ', $name!' : '!'}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Today • $today',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _showProfileDialog(context, name),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showProfileDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name.isNotEmpty ? name : 'Guest',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Consumer<AuthNotifier>(
                  builder: (context, auth, _) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      label: const Text('Log out'),
                      onPressed: () async {
                        await auth.logout();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthMetricCard(BuildContext context, AuthNotifier auth) {
    final weight = auth.todayWeight;

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.monitor_weight,
                  color: primaryColor,
                  size: 30,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                weight != null ? weight.toStringAsFixed(1) : '--',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'น้ำหนักวันนี้ (kg)',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _showWeightInputDialog(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: primaryColor,
                  backgroundColor: secondaryColor.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('บันทึกน้ำหนัก'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWeightInputDialog(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('บันทึกน้ำหนักวันนี้'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'น้ำหนัก (kg)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) Navigator.pop(context, value);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
    if (result != null) {
      await context.read<AuthNotifier>().saveTodayWeight(result);
    }
  }

  Widget _buildProgressSection() {
  return Consumer<AuthNotifier>(
    builder: (context, auth, _) {
      final waterCount = auth.dailyWaterCount;
      final waterGoal = 8; // สมมุติว่าเป้าหมายคือ 8 แก้ว
      final waterProgress = (waterCount / waterGoal).clamp(0.0, 1.0);
      final waterText = '${(waterProgress * 100).toInt()}%';

      // Optional: meals
      // final mealsLogged = auth.mealsLogged; // ต้องมีใน AuthNotifier
      // final mealGoal = auth.mealGoal;       // ต้องมีใน AuthNotifier
      // final mealProgress = mealGoal == 0 ? 0.0 : mealsLogged / mealGoal;
      // final mealText = '$mealsLogged/$mealGoal';

      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Progress",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildProgressItem(
                icon: Icons.water_drop,
                label: 'Water Intake',
                progress: waterProgress,
                progressText: waterText,
              ),
              const SizedBox(height: 15),
              _buildProgressItem(
                icon: Icons.accessibility,
                label: 'Exercise',
                progress: 1.0,
                progressText: 'Done',
              ),
              const SizedBox(height: 15),
              _buildProgressItem(
                icon: Icons.fastfood,
                label: 'Meals',
                progress: 0.66,
                progressText: '2/3',
              ),
            ],
          ),
        ),
      );
    },
  );
}


  Widget _buildProgressItem({
    required IconData icon,
    required String label,
    required double progress,
    required String progressText,
  }) {
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: secondaryColor.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Text(progressText),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 2.5,
              children: [
                _buildActionButton('Log Water', context, '/daily_habits'),
                _buildActionButton('Add Meal', context, '/meal_logging'),
                _buildActionButton('Track Mood', context, null),
                _buildActionButton('Log Exercise', context, '/daily_habits'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    BuildContext context,
    String? routeName,
  ) {
    return ElevatedButton(
      onPressed: () {
        if (routeName != null) {
          Navigator.pushNamed(context, routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('"$label" feature is coming soon!')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: secondaryColor.withOpacity(0.2),
        overlayColor: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(label),
    );
  }
}
