import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../providers/auth_notifier.dart'; 
import 'login_screen.dart'; 

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? errorText, 
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFF0ABAB5), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        errorText: errorText, // ใช้ errorText ที่รับเข้ามา
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _usernameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    // ตั้งค่า callback สำหรับ SnackBar
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

    Future<void> _register() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      // ตรวจสอบรหัสผ่านตรงกันก่อนเรียก AuthNotifier
      if (_passwordController.text != _confirmPasswordController.text) {
        authNotifier.setSnackBarCallback((message, {bool isError = false}) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("รหัสผ่านไม่ตรงกัน"),
              backgroundColor: Colors.red.shade700,
            ),
          );
        });
        return;
      }

      await authNotifier.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // ถ้าลงทะเบียนสำเร็จ (ไม่มีข้อผิดพลาดและไม่ได้อยู่ในสถานะโหลด)
      if (!authNotifier.isLoading && authNotifier.emailError == null && authNotifier.passwordError == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }

    // Widget สำหรับสร้างปุ่ม "Create account"
    Widget _buildCreateAccountButton() {
      return Consumer<AuthNotifier>(
        builder: (context, auth, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0ABAB5),
                  Color(0xFF56DFCF),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0ABAB5).withAlpha((255 * 0.4).round()),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: auth.isLoading ? null : _register, // ปิดการใช้งานปุ่มเมื่อกำลังโหลด
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
                            'Create account',
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
      );
    }

    Widget _buildSignInLink() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Have an account? ",
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF56DFCF),
                          Color(0xFF0ABAB5),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((255 * 0.2).round()),
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
                  const SizedBox(height: 40),
                  const Text(
                    'Create your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ช่องกรอก Username
                  _buildTextFormField(
                    controller: _usernameController,
                    hintText: 'Username',
                    validator: (value) =>
                        value!.isEmpty ? "Please enter a username" : null,
                  ),
                  const SizedBox(height: 20),

                  // ช่องกรอก Email
                  Consumer<AuthNotifier>(
                    builder: (context, auth, child) {
                      return _buildTextFormField(
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please enter an email";
                          final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!emailRegex.hasMatch(value)) return 'รูปแบบอีเมลไม่ถูกต้อง';
                          return null;
                        },
                        errorText: auth.emailError, // ดึงข้อความ Error จาก AuthNotifier
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // ช่องกรอก Password
                  Consumer<AuthNotifier>(
                    builder: (context, auth, child) {
                      return _buildTextFormField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        validator: (value) => value!.length < 6
                            ? "Password must be at least 6 characters"
                            : null,
                        errorText: auth.passwordError, // ดึงข้อความ Error จาก AuthNotifier
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // ช่องกรอก Confirm password
                  _buildTextFormField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm password',
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // ปุ่ม "Create account"
                  _buildCreateAccountButton(),
                  const SizedBox(height: 30),

                  // ลิงค์สำหรับ Sign In
                  _buildSignInLink(),
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
