import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ✅ ต้องอยู่นอกคลาส และใส่ pragma
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
  // ถ้าเป็น data-only และอยากเด้งตอน background ต้องใช้ android_alarm_manager/foreground service เพิ่ม
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final _fln = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Channel for foreground FCM notifications',
    importance: Importance.high,
  );

  static Future<String?> initializeFCM() async {
    // init local noti
    const init = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _fln.initialize(init);
    await _fln
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    if (kDebugMode) print('FCM Token: $token');
    return token;
  }

  static void setupOnMessageHandlers() {
    // ✅ ใช้ฟังก์ชัน top-level ที่เราย้ายออกมา
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  if (kDebugMode) {
    print('Received a message in foreground: ${message.notification?.title}');
  }

  final n = message.notification;
  // เด้งตอน foreground แม้ n.android จะเป็น null
  if (n != null) {
    await _fln.show(
      n.hashCode,
      n.title,
      n.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Channel for foreground FCM notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher', // หรือ @drawable/ic_stat_notification ถ้ามี
        ),
      ),
    );
  }
});


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Notification clicked: ${message.notification?.title}');
      }
    });
  }

  static Future<void> handleInitialMessage(BuildContext context) async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        print('App opened from terminated by notification: ${initialMessage.notification?.title}');
      }
    }
  }
}
