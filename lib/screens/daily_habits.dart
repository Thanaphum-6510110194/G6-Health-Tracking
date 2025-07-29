import 'package:flutter/material.dart';

// กำหนดค่าสีหลักตามที่คุณต้องการ
const Color primaryColor = Color(0xFF0ABAB5);
const Color gradientColor = Color(0xFF56DFCF);
const Color textColor = Color(0xFF000000);
const Color textOnButtonColor = Color(0xFFFFFFFF);
const Color cardBackgroundColor = Colors.white;
const Color screenBackgroundColor = Color(0xFFF0F4F8);
const Color secondaryTextColor = Colors.grey;

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'Inter', // แนะนำให้ใช้ฟอนต์ที่ดูสะอาดตา
        scaffoldBackgroundColor: screenBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: textColor),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // --- ส่วนหัว ---
            const Text(
              'Daily Habits',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track your wellness journey',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 32),

            // --- การ์ดแสดงผล ---
            const WaterIntakeCard(),
            const SizedBox(height: 20),
            const ExerciseCard(),
            const SizedBox(height: 20),
            const SleepCard(),
          ],
        ),
      ),
    );
  }
}

// --- Widget สำหรับการ์ดดื่มน้ำ (เปลี่ยนเป็น StatefulWidget) ---
class WaterIntakeCard extends StatefulWidget {
  const WaterIntakeCard({super.key});

  @override
  State<WaterIntakeCard> createState() => _WaterIntakeCardState();
}

class _WaterIntakeCardState extends State<WaterIntakeCard> {
  // สร้าง state เพื่อเก็บจำนวนแก้วน้ำที่ดื่มแล้ว
  int _waterCount = 0;

  // ฟังก์ชันสำหรับเพิ่มจำนวนแก้วน้ำ
  void _addWater() {
    // เพิ่มจำนวนได้ไม่เกิน 8
    if (_waterCount < 8) {
      setState(() {
        _waterCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HabitCard(
      icon: Icons.water_drop,
      title: 'Water Intake',
      // แสดงผลจำนวนแก้วน้ำจาก state
      subtitle: '$_waterCount of 8 glasses',
      buttonText: '+ Add',
      // ส่งฟังก์ชัน _addWater ไปให้ปุ่มทำงาน
      onPressed: _addWater,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(8, (index) {
          return Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              // เปลี่ยนสีตามจำนวนแก้วน้ำที่ดื่มแล้ว
              color: index < _waterCount ? primaryColor : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}


// --- Widget สำหรับการ์ดออกกำลังกาย ---
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return HabitCard(
      icon: Icons.directions_run,
      title: 'Exercise',
      subtitle: '45 min today',
      buttonText: '+ Log',
      onPressed: () {
        // สามารถเพิ่ม Logic การทำงานของปุ่มนี้ได้
      },
      child: Column(
        children: [
          ExerciseLogItem(activity: 'Morning Run', duration: '30 min'),
          const SizedBox(height: 12),
          ExerciseLogItem(activity: 'Strength Training', duration: '15 min'),
        ],
      ),
    );
  }
}

class ExerciseLogItem extends StatelessWidget {
  final String activity;
  final String duration;

  const ExerciseLogItem({
    super.key,
    required this.activity,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(activity, style: const TextStyle(fontSize: 16, color: textColor)),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widget สำหรับการ์ดนอนหลับ ---
class SleepCard extends StatelessWidget {
  const SleepCard({super.key});

  @override
  Widget build(BuildContext context) {
    return HabitCard(
      icon: Icons.bedtime,
      title: 'Sleep',
      subtitle: '8h 15m last night',
      buttonText: 'Update',
      onPressed: () {
        // สามารถเพิ่ม Logic การทำงานของปุ่มนี้ได้
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Quality', style: TextStyle(fontSize: 16, color: textColor)),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: Colors.amber.shade400,
                  size: 24,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Widget การ์ดหลัก (Reusable) (เพิ่ม onPressed) ---
class HabitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final Widget child;
  final VoidCallback? onPressed; // เพิ่ม callback สำหรับการกดปุ่ม

  const HabitCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.child,
    this.onPressed, // เพิ่มใน constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // --- ไอคอนพร้อมพื้นหลังไล่สี ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryColor, gradientColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: textOnButtonColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              // --- ปุ่ม ---
              TextButton(
                onPressed: onPressed, // เรียกใช้ callback ที่ส่งเข้ามา
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
