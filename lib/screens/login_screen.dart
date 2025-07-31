import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_tracking/services/auth_service.dart'; // ตรวจสอบว่า path ถูกต้อง
import 'profile_page.dart'; // ตรวจสอบว่ามีไฟล์นี้อยู่
import 'register_screen.dart'; // ตรวจสอบว่ามีไฟล์นี้อยู่

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key สำหรับจัดการ Form
  final _formKey = GlobalKey<FormState>();

  // Controllers สำหรับรับค่าจาก TextFormFields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State สำหรับจัดการ UI
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  // Instance ของ AuthService
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ฟังก์ชันสำหรับแสดง SnackBar เมื่อมีข้อผิดพลาดทั่วไป
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  // ฟังก์ชันหลักสำหรับจัดการการเข้าสู่ระบบ
  Future<void> _login() async {
    // 1. ล้างข้อผิดพลาดเก่า (จาก server) ก่อน
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // 2. ตรวจสอบความถูกต้องของข้อมูลในฟอร์ม (client-side validation)
    if (!_formKey.currentState!.validate()) {
      return; // ถ้าข้อมูลไม่ถูกต้อง, หยุดการทำงาน
    }

    // 3. แสดง loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // 4. เรียกใช้ AuthService เพื่อทำการล็อกอิน
      await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      // 5. หากสำเร็จ นำทางไปยังหน้าโปรไฟล์
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("เข้าสู่ระบบสำเร็จ!"),
            backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BasicProfileScreen()),
      );

    } on FirebaseAuthException catch (e) {
      // 6. จัดการ Error จาก Firebase และแสดงข้อความใต้ช่องที่ผิดพลาด
      if (mounted) {
        setState(() {
          switch (e.code) {
            case 'user-not-found':
            case 'invalid-email':
              _emailError = 'ไม่พบบัญชีผู้ใช้สำหรับอีเมลนี้';
              break;
            case 'wrong-password':
              _passwordError = 'รหัสผ่านไม่ถูกต้อง';
              break;
            // 'invalid-credential' เป็น error code ที่ใหม่กว่าและครอบคลุมทั้ง 2 กรณี
            case 'invalid-credential':
              _passwordError = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
              break;
            default:
              // หากเป็น Error อื่นๆ ที่ไม่เจาะจง ให้แสดงเป็น SnackBar
              _showErrorSnackBar('เกิดข้อผิดพลาด: ${e.message}');
          }
        });
      }
    } catch (e) {
      // จัดการข้อผิดพลาดที่ไม่คาดคิดอื่นๆ
      _showErrorSnackBar("เกิดข้อผิดพลาดที่ไม่คาดคิด: $e");
    } finally {
      // 7. ซ่อน loading indicator ไม่ว่าจะสำเร็จหรือล้มเหลว
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF56DFCF), Color(0xFF0ABAB5)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.favorite, color: Colors.white, size: 60),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // TextFormField สำหรับ Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      errorText: _emailError, // แสดงข้อความ Error จาก State
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'กรุณากรอกอีเมล';
                      final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (!emailRegex.hasMatch(value)) return 'รูปแบบอีเมลไม่ถูกต้อง';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // TextFormField สำหรับ Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      errorText: _passwordError, // แสดงข้อความ Error จาก State
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'กรุณากรอกรหัสผ่าน';
                      if (value.length < 6) return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // ปุ่ม Forgot password?
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () { /* TODO: Implement forgot password */ },
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ปุ่ม Sign In
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0ABAB5), Color(0xFF56DFCF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0ABAB5).withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isLoading ? null : _login,
                        borderRadius: BorderRadius.circular(12.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ลิงค์สำหรับ Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                      GestureDetector(
                        onTap: _navigateToRegister,
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0xFF0ABAB5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
