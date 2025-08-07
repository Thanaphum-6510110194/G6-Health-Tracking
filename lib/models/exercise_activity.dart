import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseActivity {
  String id;
  String name;
  TimeOfDay scheduledTime;
  Duration goalDuration;
  // เพิ่ม field ที่จำเป็นสำหรับ UI เข้าไปที่นี่
  Duration remainingDuration;
  bool isRunning = false;
  Timer? timer;


  ExerciseActivity({
    required this.id,
    required this.name,
    required this.scheduledTime,
    required this.goalDuration,
  }) : remainingDuration = goalDuration; // กำหนดค่าเริ่มต้นให้ remainingDuration

  // แปลง TimeOfDay เป็น String "HH:mm" เพื่อเก็บใน Firestore
  static String _timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // แปลง String "HH:mm" กลับเป็น TimeOfDay
  static TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // สร้าง instance จาก Map ของ Firestore
  factory ExerciseActivity.fromMap(String id, Map<String, dynamic> map) {
    return ExerciseActivity(
      id: id,
      name: map['name'] ?? 'Untitled',
      scheduledTime: _stringToTimeOfDay(map['scheduledTime'] ?? '00:00'),
      goalDuration: Duration(seconds: map['goalDurationInSeconds'] ?? 0),
    );
  }

  // แปลง instance เป็น Map เพื่อบันทึกลง Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'scheduledTime': _timeOfDayToString(scheduledTime),
      'goalDurationInSeconds': goalDuration.inSeconds,
      'updatedAt': Timestamp.now(),
    };
  }
}