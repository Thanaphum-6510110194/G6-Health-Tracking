import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  // Notification Settings data
  Map<String, dynamic>? _notificationSettingsData;
  Map<String, dynamic>? get notificationSettingsData => _notificationSettingsData;

  Future<void> fetchNotificationSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _notificationSettingsData = null;
      notifyListeners();
      return;
    }
    final userId = user.uid;
    try {
      final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('notification_settings')
        .get();
      if (doc.exists) {
        _notificationSettingsData = doc.data();
      } else {
        _notificationSettingsData = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching notification settings: $e');
      _notificationSettingsData = null;
      notifyListeners();
    }
  }

  Future<void> saveNotificationSettings({
    required bool waterRemindersEnabled,
    required bool exerciseRemindersEnabled,
    required bool mealLoggingEnabled,
    required bool sleepRemindersEnabled,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;
    final newNotificationSettings = {
      'waterRemindersEnabled': waterRemindersEnabled,
      'exerciseRemindersEnabled': exerciseRemindersEnabled,
      'mealLoggingEnabled': mealLoggingEnabled,
      'sleepRemindersEnabled': sleepRemindersEnabled,
      'updatedAt': Timestamp.now(),
    };
    if (_notificationSettingsData != null &&
        _notificationSettingsData!['waterRemindersEnabled'] == waterRemindersEnabled &&
        _notificationSettingsData!['exerciseRemindersEnabled'] == exerciseRemindersEnabled &&
        _notificationSettingsData!['mealLoggingEnabled'] == mealLoggingEnabled &&
        _notificationSettingsData!['sleepRemindersEnabled'] == sleepRemindersEnabled) {
      return;
    }
    try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('notification_settings')
        .set(newNotificationSettings);
      _notificationSettingsData = newNotificationSettings;
      notifyListeners();
    } catch (e) {
      print('Error saving notification settings: $e');
    }
  }
  // Lifestyle Habits data
  Map<String, dynamic>? _lifestyleHabitsData;
  Map<String, dynamic>? get lifestyleHabitsData => _lifestyleHabitsData;

  Future<void> fetchLifestyleHabits() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _lifestyleHabitsData = null;
      notifyListeners();
      return;
    }
    final userId = user.uid;
    try {
      final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('lifestyle_habits')
        .get();
      if (doc.exists) {
        _lifestyleHabitsData = doc.data();
      } else {
        _lifestyleHabitsData = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching lifestyle habits: $e');
      _lifestyleHabitsData = null;
      notifyListeners();
    }
  }

  Future<void> saveLifestyleHabits({
    required String sleepDuration,
    required String waterIntake,
    required String stressLevel,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;
    final newLifestyleHabits = {
      'sleepDuration': sleepDuration,
      'waterIntake': waterIntake,
      'stressLevel': stressLevel,
      'updatedAt': Timestamp.now(),
    };
    if (_lifestyleHabitsData != null &&
        _lifestyleHabitsData!['sleepDuration'] == sleepDuration &&
        _lifestyleHabitsData!['waterIntake'] == waterIntake &&
        _lifestyleHabitsData!['stressLevel'] == stressLevel) {
      return;
    }
    try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('lifestyle_habits')
        .set(newLifestyleHabits);
      _lifestyleHabitsData = newLifestyleHabits;
      notifyListeners();
    } catch (e) {
      print('Error saving lifestyle habits: $e');
    }
  }
  // About Yourself data
  Map<String, dynamic>? _aboutYourselfData;
  Map<String, dynamic>? get aboutYourselfData => _aboutYourselfData;

  Future<void> fetchAboutYourself() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _aboutYourselfData = null;
      notifyListeners();
      return;
    }
    final userId = user.uid;
    try {
      final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('about_yourself')
        .get();
      if (doc.exists) {
        _aboutYourselfData = doc.data();
      } else {
        _aboutYourselfData = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching about yourself: $e');
      _aboutYourselfData = null;
      notifyListeners();
    }
  }

  Future<void> saveAboutYourself({
    required String? healthDescription,
    required String? healthGoal,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;
    final newAboutYourself = {
      'healthDescription': healthDescription,
      'healthGoal': healthGoal,
      'updatedAt': Timestamp.now(),
    };
    if (_aboutYourselfData != null &&
        _aboutYourselfData!['healthDescription'] == healthDescription &&
        _aboutYourselfData!['healthGoal'] == healthGoal) {
      return;
    }
    try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('about_yourself')
        .set(newAboutYourself);
      _aboutYourselfData = newAboutYourself;
      notifyListeners();
    } catch (e) {
      print('Error saving about yourself: $e');
    }
  }
  // ข้อมูล Physical Info ของผู้ใช้ (สำหรับ Provider)
  Map<String, dynamic>? _physicalInfoData;
  Map<String, dynamic>? get physicalInfoData => _physicalInfoData;

  // ดึงข้อมูล Physical Info จาก Firestore สำหรับผู้ใช้ที่ล็อกอิน
  Future<void> fetchPhysicalInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _physicalInfoData = null;
      notifyListeners();
      return;
    }
    final userId = user.uid;
    try {
      final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('physical_info')
        .get();
      if (doc.exists) {
        _physicalInfoData = doc.data();
      } else {
        _physicalInfoData = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching physical info: $e');
      _physicalInfoData = null;
      notifyListeners();
    }
  }

  // บันทึกข้อมูล Physical Info ไปยัง Firestore สำหรับผู้ใช้ที่ล็อกอิน
  Future<void> savePhysicalInfo({
    required String weight,
    required String height,
    required String? activityLevel,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;
    final newPhysicalInfo = {
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
      'updatedAt': Timestamp.now(),
    };

    // Compare with existing data
    if (_physicalInfoData != null &&
        _physicalInfoData!['weight'] == weight &&
        _physicalInfoData!['height'] == height &&
        _physicalInfoData!['activityLevel'] == activityLevel) {
      // No changes, skip saving
      return;
    }

    try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('physical_info')
        .set(newPhysicalInfo);
      _physicalInfoData = newPhysicalInfo;
      notifyListeners();
    } catch (e) {
      print('Error saving physical info: $e');
    }
  }
  // บันทึกข้อมูลโปรไฟล์ไปยัง Firestore สำหรับผู้ใช้ที่ล็อกอิน
  Future<void> saveProfileData({
    required String fullName,
    required String dateOfBirth,
    required String? gender,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;
    final newProfileData = {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'createdAt': Timestamp.now(),
    };

    // Compare with existing data
    if (_profileData != null &&
        _profileData!['fullName'] == fullName &&
        _profileData!['dateOfBirth'] == dateOfBirth &&
        _profileData!['gender'] == gender) {
      // No changes, skip saving
      return;
    }

    try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('profile_data')
        .set(newProfileData);
      _profileData = newProfileData;
      notifyListeners();
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }
  // ข้อมูลโปรไฟล์ของผู้ใช้ (สำหรับ Provider)
  Map<String, dynamic>? _profileData;
  Map<String, dynamic>? get profileData => _profileData;

  // ดึงข้อมูลโปรไฟล์จาก Firestore สำหรับผู้ใช้ที่ล็อกอิน
  Future<void> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _profileData = null;
      notifyListeners();
      return;
    }
    final userId = user.uid;
    try {
      final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('profile')
        .doc('profile_data')
        .get();
      if (doc.exists) {
        _profileData = doc.data();
      } else {
        _profileData = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching profile data: $e');
      _profileData = null;
      notifyListeners();
    }
  }
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
