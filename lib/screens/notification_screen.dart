import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_notifier.dart';
import 'main_navigation_screen.dart';
import 'dashboard.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      await authNotifier.fetchNotificationSettings();
      final data = authNotifier.notificationSettingsData;
      if (data != null) {
        setState(() {
          _waterRemindersEnabled = data['waterRemindersEnabled'] ?? true;
          _exerciseRemindersEnabled = data['exerciseRemindersEnabled'] ?? true;
          _mealLoggingEnabled = data['mealLoggingEnabled'] ?? false;
          _sleepRemindersEnabled = data['sleepRemindersEnabled'] ?? true;
        });
      }
    });
  }
  bool _waterRemindersEnabled = true;
  bool _exerciseRemindersEnabled = true;
  bool _mealLoggingEnabled = false;
  bool _sleepRemindersEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0ABAB5)),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปหน้า LifestyleHabitsScreen
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                color: Color(0xFF0ABAB5),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 5 / 5, // Step 5 of 5 (ขั้นตอนสุดท้าย)
                      backgroundColor: Colors.grey[300],
                      color: const Color(0xFF0ABAB5),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Step 5 of 5', // แสดง Step 5 of 5
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // จัดให้อยู่ตรงกลาง
          children: <Widget>[
            const Icon(
              Icons.notifications_active_outlined, // ไอคอนกระดิ่ง
              size: 80,
              color: Color(0xFF0ABAB5),
            ),
            const SizedBox(height: 16),
            Text(
              'Set up gentle reminders to help you stay\non track with your health goals',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 40),

            // Reminder Cards
            _buildReminderCard(
              icon: Icons.water_drop,
              iconColor: Colors.blue,
              title: 'Water Reminders',
              subtitle: 'Every 2 hours, 9 AM - 9 PM',
              value: _waterRemindersEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  _waterRemindersEnabled = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildReminderCard(
              icon: Icons.directions_run,
              iconColor: Colors.orange,
              title: 'Exercise Reminders',
              subtitle: 'Daily at 7 AM',
              value: _exerciseRemindersEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  _exerciseRemindersEnabled = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildReminderCard(
              icon: Icons.restaurant_menu,
              iconColor: Colors.green,
              title: 'Meal Logging',
              subtitle: 'Breakfast, lunch, dinner',
              value: _mealLoggingEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  _mealLoggingEnabled = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildReminderCard(
              icon: Icons.bedtime,
              iconColor: Colors.purple,
              title: 'Sleep Reminders',
              subtitle: 'Bedtime at 10 PM',
              value: _sleepRemindersEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  _sleepRemindersEnabled = newValue;
                });
              },
            ),
            const SizedBox(height: 48),

            // Finish Button with Gradient
            SizedBox(
              width: double.infinity,
              height: 56,
              child: InkWell(
                onTap: () async {
                  final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
                  await authNotifier.saveNotificationSettings(
                    waterRemindersEnabled: _waterRemindersEnabled,
                    exerciseRemindersEnabled: _exerciseRemindersEnabled,
                    mealLoggingEnabled: _mealLoggingEnabled,
                    sleepRemindersEnabled: _sleepRemindersEnabled,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification settings saved!')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainNavigationScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0ABAB5), // Start
                        Color(0xFF56DFCF), // End
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0ABAB5).withAlpha((255 * 0.4).round()),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Finish', // ปุ่มสุดท้าย
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget สำหรับสร้าง Card แจ้งเตือน
  Widget _buildReminderCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF0ABAB5),
            ),
          ],
        ),
      ),
    );
  }
}
