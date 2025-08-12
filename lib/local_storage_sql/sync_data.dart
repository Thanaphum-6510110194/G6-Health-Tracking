import 'package:cloud_firestore/cloud_firestore.dart';
import 'local_database.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = 'e87Dl9L31JbNYHZZKVbI7vpxFQ63';

  // 🔄 Firestore → SQLite
  Future<void> syncFromFirestore() async {
    await _syncSingleDocument(
      'profile',
      'about_yourself',
      LocalDatabase.instance.updateAboutYourself,
    );
    await _syncSingleDocument(
      'profile',
      'lifestyle_habits',
      LocalDatabase.instance.updateLifestyle,
    );
    await _syncSingleDocument(
      'profile',
      'notification_settings',
      LocalDatabase.instance.updateNotification,
    );
    await _syncSingleDocument(
      'profile',
      'physical_info',
      LocalDatabase.instance.updatePhysicalInfo,
    );
    await _syncSingleDocument(
      'profile',
      'profile_data',
      LocalDatabase.instance.updateProfile,
    );
    // await _syncSingleDocument('goals', LocalDatabase.instance.updateGoals);
    await _syncUser(LocalDatabase.instance.updateUser);
  }

  // 🔄 SQLite → Firestore
  Future<void> syncToFirestore() async {
    await _uploadSingleDocument(
      'profile',
      'about_yourself',
      await LocalDatabase.instance.getAboutYourself(),
    );
    await _uploadSingleDocument(
      'profile',
      'lifestyle_habits',
      await LocalDatabase.instance.getLifestyle(),
    );
    await _uploadSingleDocument(
      'profile',
      'notification_settings',
      await LocalDatabase.instance.getNotification(),
    );
    await _uploadSingleDocument(
      'profile',
      'physical_info',
      await LocalDatabase.instance.getPhysicalInfo(),
    );
    await _uploadSingleDocument(
      'profile',
      'profile_data',
      await LocalDatabase.instance.getProfile(),
    );
    await _uploadUser(await LocalDatabase.instance.getUsers());
  }

  // --------------------- Helper Functions ---------------------

  Future<void> _syncSingleDocument(
    String groupName,
    String documentName,
    Future<void> Function(Map<String, dynamic>) saveToLocal,
  ) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection(groupName)
          .doc(documentName);

      final doc = await docRef.get();
      if (doc.exists && doc.data() != null) {
        final rawData = doc.data()!;
        final cleanedData = _sanitizeData(rawData);
        await saveToLocal(cleanedData);
        print('✅ Synced $userId from Firestore.');
      }
    } catch (e) {
      print('❌ Error syncing $userId from Firestore: $e');
    }
  }

  Future<void> _syncUser(
    Future<void> Function(Map<String, dynamic>) saveToLocal,
  ) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final rawData = doc.data()!;
        final cleanedData = _sanitizeData(rawData);
        await saveToLocal(cleanedData);
        print('✅ Synced $userId from Firestore.');
      }
    } catch (e) {
      print('❌ Error syncing $userId from Firestore: $e');
    }
  }

  Future<void> _uploadSingleDocument(
    String groupName,
    String documentName,
    Map<String, dynamic>? data,
  ) async {
    if (data == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection(groupName)
          .doc(documentName)
          .set(data);
      print('✅ Uploaded $documentName to Firestore.');
    } catch (e) {
      print('❌ Error uploading $documentName to Firestore: $e');
    }
  }

  Future<void> _uploadUser(Map<String, dynamic>? data) async {
    if (data == null) return;
    try {
      await _firestore.collection('users').doc(userId).set(data);
      print('✅ Updated $userId to Firestore.');
    } catch (e) {
      print('❌ Error Updated $userId to Firestore: $e');
    }
  }

  Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    final cleaned = <String, dynamic>{};

    data.forEach((key, value) {
      if (value is Timestamp) {
        cleaned[key] = value.toDate().toIso8601String();
      } else if (value is bool) {
        cleaned[key] = value ? 1 : 0; // ✅ แปลงเป็น 1/0 สำหรับ SQLite
      } else {
        cleaned[key] = value;
      }
    });

    return cleaned;
  }
}
