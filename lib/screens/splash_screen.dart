import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_tracking/screens/login_screen.dart';
import 'package:health_tracking/screens/dashboard.dart'; // หรือหน้า Home จริงของคุณ

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    // หน่วงเวลาเล็กน้อยเพื่อแสดง Splash Screen ก่อน
    await Future.delayed(const Duration(seconds: 3)); // แสดง Splash Screen 3 วินาที

    // ตรวจสอบสถานะการล็อกอินของผู้ใช้
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // ไม่มีผู้ใช้ล็อกอินอยู่, ไปหน้า Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // มีผู้ใช้ล็อกอินอยู่แล้ว, ไปหน้า Dashboard (หรือหน้าหลักของแอป)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ตั้งค่าพื้นหลังเป็นสีขาวตามรูป
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ไอคอนรูปหัวใจ
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6A5ACD), // สีม่วงอ่อน
                    Color(0xFF483D8B), // สีม่วงเข้ม
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite, // ไอคอนรูปหัวใจ
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 30),
            // HealthTracker Text
            const Text(
              'HealthTracker',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF483D8B), // สีเดียวกับหัวใจเข้ม
              ),
            ),
            const SizedBox(height: 10),
            // Your Minimalist Health Journey Text
            Text(
              'Your Minimalist Health Journey',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 50),
            // Get Started Button
            SizedBox(
              width: 250, // กำหนดความกว้างปุ่ม
              height: 55, // กำหนดความสูงปุ่ม
              child: ElevatedButton(
                onPressed: () {
                  // อาจจะไม่ต้องทำอะไรที่นี่ เพราะ _checkAuthStatus จะนำทางไปเอง
                  // หรือถ้าต้องการให้ปุ่มนี้กดแล้วไปหน้า Register (หากผู้ใช้ยังไม่ได้ Login)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()), // ไป Login ให้เลือก Register
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color(0xFF483D8B), // สีม่วงเข้ม
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // ปรับให้ปุ่มโค้งมน
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Already have an account? TextButton
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF483D8B), // สีเดียวกับหัวใจเข้ม
              ),
              child: const Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}