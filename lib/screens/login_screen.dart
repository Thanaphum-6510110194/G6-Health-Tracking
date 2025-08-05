import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // เพิ่ม import provider
import '../providers/auth_notifier.dart'; // เพิ่ม import AuthNotifier
import 'profile_page.dart'; // ตรวจสอบว่า path ถูกต้อง
import 'register_screen.dart'; // ตรวจสอบว่า path ถูกต้อง

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authNotifier.setSnackBarCallback((message, {bool isError = false}) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isError ? Colors.red.shade700 : Colors.green,
          ),
        );
      });
    });

    // ฟังก์ชันหลักสำหรับจัดการการเข้าสู่ระบบ
    Future<void> _login() async {
      if (!_formKey.currentState!.validate()) {
        return; // ถ้าข้อมูลไม่ถูกต้อง, หยุดการทำงาน
      }

      await authNotifier.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // ตรวจสอบว่าล็อกอินสำเร็จหรือไม่
      if (!authNotifier.isLoading && authNotifier.emailError == null && authNotifier.passwordError == null) {
        // ถ้าไม่มีข้อผิดพลาดและไม่ได้อยู่ในสถานะโหลด แสดงว่าล็อกอินสำเร็จ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BasicProfileScreen()),
        );
      }
    }

    void _navigateToRegister() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    }

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
                  Consumer<AuthNotifier>(
                    builder: (context, auth, child) {
                      return TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          errorText: auth.emailError, // ดึงข้อความ Error จาก AuthNotifier
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'กรุณากรอกอีเมล';
                          final emailRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!emailRegex.hasMatch(value)) return 'รูปแบบอีเมลไม่ถูกต้อง';
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // TextFormField สำหรับ Password
                  Consumer<AuthNotifier>(
                    builder: (context, auth, child) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          errorText: auth.passwordError, // ดึงข้อความ Error จาก AuthNotifier
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'กรุณากรอกรหัสผ่าน';
                          if (value.length < 6) return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                          return null;
                        },
                      );
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
                  Consumer<AuthNotifier>(
                    builder: (context, auth, child) {
                      return Container(
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
                            onTap: auth.isLoading ? null : _login, // ปิดการใช้งานปุ่มเมื่อกำลังโหลด
                            borderRadius: BorderRadius.circular(12.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: auth.isLoading // แสดง CircularProgressIndicator เมื่อกำลังโหลด
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
                      );
                    },
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