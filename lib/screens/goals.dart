import 'package:flutter/material.dart';

// กำหนดค่าสีหลักตามที่ผู้ใช้ต้องการ
const Color primaryColor = Color(0xFF0ABAB5);
const Color gradientColor = Color(0xFF56DFCF);
const Color textColor = Color(0xFF000000);
const Color textOnButtonColor = Color(0xFFFFFFFF);
const Color backgroundColor = Color(0xFFF5F8FF); // สีพื้นหลังอ่อนๆ จากรูปภาพ
const Color cardBackgroundColor = Colors.white;
const Color goalCardColor = Color(0xFFE6F7FF);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goals & Achievements UI',
      theme: ThemeData(
        fontFamily: 'Poppins', // ใช้ฟอนต์ที่ดูทันสมัย (สามารถเปลี่ยนได้)
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
      ),
      home: const GoalsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 30),
                _buildActiveGoalsCard(),
                const SizedBox(height: 30),
                _buildCurrentStreaksCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget สำหรับสร้างส่วนหัว (Header)
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Goals',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            height: 1.2,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, color: primaryColor, size: 20),
          label: const Text(
            'New Goal',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE3F2FD), // สีพื้นหลังปุ่มแบบอ่อน
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  // Widget สำหรับการ์ด "Active Goals"
  Widget _buildActiveGoalsCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Goals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildGoalItem(
            title: 'Lose 10 lbs in 3 months',
            progressText: 'Progress: 3 lbs lost',
            value: 0.3,
          ),
          const SizedBox(height: 15),
          _buildGoalItem(
            title: 'Exercise 5 times per week',
            progressText: 'This week: 3/5 completed',
            value: 0.6,
          ),
        ],
      ),
    );
  }

  // Widget สำหรับแต่ละรายการใน "Active Goals"
  Widget _buildGoalItem({
    required String title,
    required String progressText,
    required double value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: goalCardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  progressText,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget สำหรับการ์ด "Current Streaks"
  Widget _buildCurrentStreaksCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Streaks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildStreakItem(
            icon: Icons.water_drop,
            iconColor: Colors.blue,
            title: 'Daily Water Goal',
            streak: '12',
            streakUnit: 'days',
            flame: true,
          ),
          const Divider(height: 30),
           _buildStreakItem(
            icon: Icons.directions_run,
            iconColor: Colors.orange,
            title: 'Morning Run',
            streak: '5',
            streakUnit: 'days',
            flame: false,
          ),
        ],
      ),
    );
  }

  // Widget สำหรับแต่ละรายการใน "Current Streaks"
  Widget _buildStreakItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String streak,
    required String streakUnit,
    required bool flame,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          radius: 25,
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Row(
               children: [
                 Text(
                  streak,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
            ),
            if (flame)
            const SizedBox(width: 4),
            if (flame)
            const Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
               ],
             ),
            Text(
              streakUnit,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
