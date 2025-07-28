import 'package:flutter/material.dart';
import 'package:health_tracking/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import this
import 'register_screen.dart';
import 'profile_page.dart';

// ฟังก์ชันหลักในการรันแอปพลิเคชัน
// This main is probably incorrect if you have a main.dart in lib/ with Firebase.initializeApp
// Ensure you only have one main() function in your entire lib/ directory, usually in main.dart
// For now, I'm keeping it as is based on the provided snippet.
void main() {
  runApp(const MyApp());
}

// Widget หลักของแอปพลิเคชัน
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false, // ปิดแถบ Debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      home: const LoginScreen(),
    );
  }
}

// Widget สำหรับหน้าจอ Login (เปลี่ยนเป็น StatefulWidget)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers สำหรับรับค่าจาก TextField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Instance ของ AuthService
  final AuthService _authService = AuthService();

  // ฟังก์ชันสำหรับจัดการการ Login
  void _login() async {
    // ป้องกันการกดซ้ำซ้อน และตรวจสอบว่า context ยังใช้งานได้
    if (!mounted) return;

    final user = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (user != null) {
      // หาก Login สำเร็จ ไปยังหน้า BasicProfileScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BasicProfileScreen()),
      );
    } else {
      // หาก Login ไม่สำเร็จ แสดง SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed. Please check your credentials."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ฟังก์ชันสำหรับไปยังหน้า Register
  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    // คืนค่า memory ให้กับ controller เมื่อ widget ถูกทำลาย
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40.0),

                // *** ส่วนที่แก้ไข: แทนที่ Placeholder ด้วยไอคอนรูปหัวใจพร้อม Gradient และ Shadow ***
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF56DFCF), // ฟ้าสดใส
                        Color(0xFF0ABAB5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                // *** สิ้นสุดการแก้ไข ***

                const SizedBox(height: 24.0),

                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 48.0),

                // ช่องกรอก Email ที่เชื่อมกับ Controller
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.blue.shade500!, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),

                // ช่องกรอก Password ที่เชื่อมกับ Controller
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.blue.shade500!, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 24.0),

                // ปุ่ม Sign In ที่มีการไล่สี
                InkWell(
                  onTap: _login,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0ABAB5), // เริ่มต้น
                          Color(0xFF56DFCF), // สิ้นสุด
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0ABAB5).withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                TextButton(
                  onPressed: () {
                    // TODO: เพิ่มฟังก์ชันการทำงานเมื่อกดปุ่ม Forgot Password
                  },
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 24.0),

                Row(
                  children: <Widget>[
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR', style: TextStyle(color: Colors.grey[600])),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24.0),

                // ปุ่ม Sign in with Google
                ElevatedButton.icon(
                  icon: SvgPicture.network(
                    'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                    height: 22.0,
                  ),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    // TODO: เพิ่มฟังก์ชันการทำงานเมื่อกดปุ่ม Sign in with Google
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2D2D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 40.0),

                // ข้อความสำหรับ "Sign Up" ที่เรียกใช้ฟังก์ชัน _navigateToRegister
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                    GestureDetector(
                      onTap: _navigateToRegister,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}