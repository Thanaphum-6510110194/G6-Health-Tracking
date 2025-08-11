
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print('Handling a background message: ${message.messageId}');
    }
  }

  static Future<String?> initializeFCM() async {
    await _messaging.requestPermission();
    String? token = await _messaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }
    return token;
  }

  static void setupOnMessageHandlers() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received a message in foreground: ${message.notification?.title}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Notification clicked: ${message.notification?.title}');
      }
    });
  }

  /// สำหรับกรณีเปิดแอปจาก terminated state ด้วย notification
  static Future<void> handleInitialMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        print('App opened from terminated by notification: ${initialMessage.notification?.title}');
      }
    }
  }
}
