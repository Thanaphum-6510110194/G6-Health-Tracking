import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // โยน Exception ที่เกี่ยวกับ Firebase กลับไปให้ UI จัดการ
      throw e;
    } catch (e) {
      // **ส่วนที่แก้ไข:**
      // หากเจอข้อผิดพลาดอื่นๆ (เช่น Firebase ยังไม่ได้ตั้งค่า)
      // ให้โยน Exception กลับไปเสมอ แทนที่จะคืนค่า null
      // เพื่อให้ UI รู้ว่าเกิดข้อผิดพลาดขึ้น
      if (kDebugMode) {
        print("An unexpected error occurred in AuthService: ${e.toString()}");
      }
      // โยน Exception เพื่อให้ UI นำไปแสดงผลใน SnackBar
      throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ กรุณาตรวจสอบการตั้งค่า');
    }
  }

  // คุณสามารถเพิ่มฟังก์ชันอื่นๆ ที่เกี่ยวกับ Auth ได้ที่นี่
  // เช่น register, signOut, etc.
}
