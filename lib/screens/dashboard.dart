import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart';
import 'package:provider/provider.dart';
import '../providers/auth_notifier.dart';


const Color primaryColor = Color(0xFF0ABAB5);
const Color secondaryColor = Color(0xFF56DFCF);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // ดึงน้ำหนักวันนี้เมื่อเข้า Dashboard
    Future.microtask(() => Provider.of<AuthNotifier>(context, listen: false).fetchTodayWeight());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(),
                const SizedBox(height: 20),
                _buildHealthMetricCards(),
                const SizedBox(height: 20),
                _buildProgressSection(),
                const SizedBox(height: 20),
                _buildQuickActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String getGreeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) return 'Good morning';
      if (hour < 17) return 'Good afternoon';
      return 'Good evening';
    }
    final today = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
    return FutureBuilder<String?>(
      future: fetchUserName(),
      builder: (context, snapshot) {
        final name = snapshot.data ?? '';
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${getGreeting()}${name.isNotEmpty ? ', $name!' : '!'}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Today • $today',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // The profile picture placeholder (first letter of name or ?)
            Container(
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
          ],
        );
      },
    );
  }

  Widget _buildHealthMetricCards() {
    return Consumer<AuthNotifier>(
      builder: (context, auth, _) {
        final weight = auth.todayWeight;
        return Row(
          children: <Widget>[
            Expanded(
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
                        child: Icon(Icons.monitor_weight, color: primaryColor, size: 30),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        weight != null ? weight.toStringAsFixed(1) : '--',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text('น้ำหนักวันนี้ (kg)', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final controller = TextEditingController();
                          final result = await showDialog<double>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('บันทึกน้ำหนักวันนี้'),
                              content: TextField(
                                controller: controller,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                    if (value != null && value > 0) {
                                      Navigator.pop(context, value);
                                    }
                                  },
                                  child: const Text('บันทึก'),
                                ),
                              ],
                            ),
                          );
                          if (result != null) {
                            await auth.saveTodayWeight(result);
                          }
                        },
                        child: const Text('บันทึกน้ำหนัก'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: primaryColor,
                          backgroundColor: secondaryColor.withOpacity(0.2),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildProgressSection() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Today's Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildProgressItem(
              icon: Icons.water_drop,
              label: 'Water Intake',
              progress: 0.75,
              progressText: '75%',
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
              SizedBox(
                height: 8,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: secondaryColor.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
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
          children: <Widget>[
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // The grid for the buttons
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true, // Important to allow GridView inside Column
              physics:
                  const NeverScrollableScrollPhysics(), // Disables scrolling for the grid
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 2.5, // Adjusts the height of the buttons
              children: <Widget>[
                _buildActionButton(label: 'Log Water', context: context, routeName: '/daily_habits'),
                _buildActionButton(label: 'Add Meal', context: context, routeName: '/meal_logging'),
                _buildActionButton(label: 'Track Mood', context: context, routeName: null),
                _buildActionButton(label: 'Log Exercise', context: context, routeName: '/daily_habits'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required BuildContext context,
    required String? routeName,
    }) {
    return ElevatedButton(
      onPressed: () {
        // ตรวจสอบว่า routeName ไม่ใช่ null ก่อนที่จะทำการ navigate
        if (routeName != null) {
          // เปลี่ยนจาก Navigator.push เป็น Navigator.pushNamed
          Navigator.pushNamed(context, routeName);
        } else {
          // จัดการกรณีที่ยังไม่มีหน้าจอสำหรับปุ่มนั้นๆ
          print('No route defined for: $label');
          // อาจจะแสดง SnackBar หรือ Dialog แจ้งเตือนผู้ใช้
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"$label" feature is coming soon!'),
              backgroundColor: Colors.grey[700],
            ),
          );
        }
        },
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: secondaryColor.withValues(alpha: 0.2),
        overlayColor: secondaryColor,
        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      
      child: Text(label),
    );
  }
}
