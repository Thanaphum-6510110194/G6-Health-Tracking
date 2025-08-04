import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  // Instance ของ AuthService สำหรับเรียกใช้ Firebase Auth
  final AuthService _authService = AuthService();

  // สถานะการโหลด (เช่น เมื่อกำลังล็อกอิน/ลงทะเบียน)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ข้อความแสดงข้อผิดพลาดสำหรับอีเมลและรหัสผ่าน
  String? _emailError;
  String? get emailError => _emailError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  // ฟังก์ชันสำหรับแสดง SnackBar (จะถูกเรียกจาก UI)
  Function(String message, {bool isError})? _showSnackBar;

  void setSnackBarCallback(Function(String message, {bool isError}) callback) {
    _showSnackBar = callback;
  }

  void _showErrorSnackBar(String message) {
    _showSnackBar?.call(message, isError: true);
  }

  void _showSuccessSnackBar(String message) {
    _showSnackBar?.call(message, isError: false);
  }

  // ฟังก์ชันสำหรับจัดการการเข้าสู่ระบบ
  Future<void> login(String email, String password) async {
    _setLoading(true); // เริ่มโหลด
    _clearErrors();    // ล้างข้อผิดพลาดเก่า

    try {
      await _authService.login(email, password);
      _showSuccessSnackBar("เข้าสู่ระบบสำเร็จ!");
      // ไม่ต้อง navigate ที่นี่ เพราะ UI จะเป็นผู้จัดการการ navigate หลังจาก provider แจ้งเตือนสถานะ
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e); // จัดการข้อผิดพลาดจาก Firebase
    } catch (e) {
      _showErrorSnackBar("เกิดข้อผิดพลาดที่ไม่คาดคิด: $e");
    } finally {
      _setLoading(false); // หยุดโหลด
    }
  }

  // ฟังก์ชันสำหรับจัดการการลงทะเบียน
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    _setLoading(true); // เริ่มโหลด
    _clearErrors();    // ล้างข้อผิดพลาดเก่า

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username.trim(),
        'email': email.trim(),
        'createdAt': Timestamp.now(),
      });

      _showSuccessSnackBar("ลงทะเบียนสำเร็จ! กรุณาเข้าสู่ระบบ");
      // ไม่ต้อง navigate ที่นี่
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e); // จัดการข้อผิดพลาดจาก Firebase
    } catch (e) {
      _showErrorSnackBar("เกิดข้อผิดพลาดที่ไม่คาดคิด: $e");
    } finally {
      _setLoading(false); // หยุดโหลด
    }
  }

  // ฟังก์ชันสำหรับตั้งค่าสถานะการโหลด
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // แจ้งเตือนผู้ฟัง (UI) ว่าสถานะมีการเปลี่ยนแปลง
  }

  // ฟังก์ชันสำหรับล้างข้อผิดพลาด
  void _clearErrors() {
    _emailError = null;
    _passwordError = null;
    notifyListeners();
  }

  // ฟังก์ชันสำหรับจัดการข้อผิดพลาดจาก FirebaseAuth
  void _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'invalid-email':
        _emailError = 'ไม่พบบัญชีผู้ใช้สำหรับอีเมลนี้';
        break;
      case 'invalid-credential':
        _passwordError = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
        break;
      case 'email-already-in-use':
        _emailError = 'อีเมลนี้ถูกใช้ไปแล้ว';
        break;
      case 'weak-password':
        _passwordError = 'รหัสผ่านอ่อนเกินไป';
        break;
      default:
        _showErrorSnackBar('เกิดข้อผิดพลาด: ${e.message}');
    }
    notifyListeners();
  }
}
