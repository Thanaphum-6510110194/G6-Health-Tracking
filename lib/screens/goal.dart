
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// กำหนดค่าสีหลักตามที่ผู้ใช้ต้องการ
const Color primaryColor = Color(0xFF0ABAB5);
const Color gradientColor = Color(0xFF56DFCF);
const Color textColor = Color(0xFF000000);
const Color textOnButtonColor = Color(0xFFFFFFFF);
const Color backgroundColor = Color(0xFFF5F8FF); // สีพื้นหลังอ่อนๆ จากรูปภาพ
const Color cardBackgroundColor = Colors.white;
const Color goalCardColor = Color(0xFFE6F7FF);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goals & Achievements UI',
      theme: ThemeData(
        fontFamily: 'Poppins', // ใช้ฟอนต์ที่ดูทันสมัย (สามารถเปลี่ยนได้)
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
      ),
      home: const GoalsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final TextEditingController _targetValueController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String _selectedGoalType = 'ลดน้ำหนัก';
  final List<String> _goalTypes = ['ลดน้ำหนัก', 'สร้างกล้ามเนื้อ', 'อื่น ๆ'];

  double? _latestWeight;


  @override
  void initState() {
    super.initState();
    _fetchLatestWeight();
  }

  Future<void> _fetchLatestWeight() async {
  // ดึงน้ำหนักล่าสุด ไม่ต้อง setState สำหรับ loading
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
  return;
    }
    final dailyWeightRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('daily_weight');
    final snapshot = await dailyWeightRef.orderBy('updatedAt', descending: true).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      _latestWeight = (data['weight'] as num?)?.toDouble();
    } else {
      _latestWeight = null;
    }
  // จบการดึงน้ำหนักล่าสุด
  }

  Future<void> _addGoalDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เพิ่มเป้าหมายใหม่'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedGoalType,
                items: _goalTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedGoalType = val!;
                  });
                },
                decoration: const InputDecoration(labelText: 'ประเภทเป้าหมาย'),
              ),
              TextField(
                controller: _targetValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _selectedGoalType == 'ลดน้ำหนัก'
                      ? 'น้ำหนักเป้าหมาย (kg)'
                      : _selectedGoalType == 'สร้างกล้ามเนื้อ'
                          ? 'กล้ามเนื้อเป้าหมาย (kg)'
                          : 'เป้าหมาย',
                ),
              ),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ระยะเวลา (วัน)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                final targetValue = double.tryParse(_targetValueController.text);
                final duration = int.tryParse(_durationController.text);
                if (user != null && targetValue != null && duration != null) {
                  final goalId = '${_selectedGoalType}_${DateTime.now().millisecondsSinceEpoch}';
                  try {
                    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('goals').doc(goalId).set({
                      'goalType': _selectedGoalType,
                      'targetValue': targetValue,
                      'duration': duration,
                      'createdAt': DateTime.now(),
                    });
                    Navigator.pop(context);
                    setState(() {
                      _targetValueController.clear();
                      _durationController.clear();
                      _selectedGoalType = _goalTypes[0];
                    });
                  } catch (e) {
                    print('Error saving goal: $e');
                    // อาจแสดง SnackBar แจ้งเตือนผู้ใช้
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกเป้าหมาย: $e')),
                      );
                    }
                  }
                } else {
                  // แจ้งเตือนถ้าข้อมูลไม่ครบหรือผิด type
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กรุณากรอกข้อมูลเป้าหมายให้ถูกต้อง')),
                    );
                  }
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Please login'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals & Achievements', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addGoalDialog(context),
            tooltip: 'Add Goal',
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Goals List ---
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('goals').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Card(
                      child: ListTile(
                        title: const Text('ยังไม่มีเป้าหมาย'),
                        subtitle: const Text('กด + เพื่อเพิ่มเป้าหมาย'),
                      ),
                    );
                  }
                  return Column(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final goalType = data['goalType'] ?? '-';
                      final targetValue = data['targetValue'] ?? '-';
                      final duration = data['duration'] ?? '-';
                      final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
                      // ดึงน้ำหนักล่าสุดจาก daily_weight
                      final currentValue = _latestWeight;
                      double progress = 0.0;
                      String targetLabel = '';
                      if (goalType == 'ลดน้ำหนัก') {
                        targetLabel = 'น้ำหนักเป้าหมาย';
                        if (currentValue != null && targetValue is num && currentValue > targetValue) {
                          final start = currentValue;
                          final end = targetValue.toDouble();
                          // สมมติว่าต้องการลดจาก currentValue ไปยัง targetValue
                          final total = start - end;
                          progress = total > 0 ? ((start - currentValue) / total).clamp(0, 1) : 0.0;
                        }
                      } else if (goalType == 'สร้างกล้ามเนื้อ') {
                        targetLabel = 'กล้ามเนื้อเป้าหมาย';
                        progress = 0.0;
                      } else {
                        targetLabel = 'เป้าหมาย';
                        progress = 0.0;
                      }
                      return Card(
                        color: goalCardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(goalType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'ลบเป้าหมาย',
                                    onPressed: () async {
                                      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('goals').doc(doc.id).delete();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('$targetLabel: $targetValue ใน $duration วัน'),
                              if (createdAt != null)
                                Text('เริ่ม: ${DateFormat('yyyy-MM-dd').format(createdAt)}'),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation(primaryColor),
                              ),
                              const SizedBox(height: 8),
                              Text('Current: $currentValue', style: TextStyle(color: textColor)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              // --- Combined Streak Card: Water & Exercise ---
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('daily_data').snapshots(),
                builder: (context, dailySnapshot) {
                  if (!dailySnapshot.hasData) return const CircularProgressIndicator();
                  final dailyDocs = dailySnapshot.data!.docs;
                  // --- Water streak calculation (robust) ---
                  // 1. Filter เฉพาะ doc ที่ water_intake >= 8 และ doc id เป็นวันที่ที่ parse ได้
                  final validEntries = dailyDocs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final id = doc.id;
                    DateTime? date;
                    try {
                      date = DateTime.parse(id);
                    } catch (_) {
                      date = null;
                    }
                    int? waterCount;
                    if (data['water_intake'] is Map && data['water_intake'] != null) {
                      waterCount = data['water_intake']['count'] is int ? data['water_intake']['count'] : int.tryParse(data['water_intake']['count']?.toString() ?? '');
                    } else if (data['water_intake'] is int) {
                      waterCount = data['water_intake'];
                    }
                    return {
                      'date': date,
                      'water_count': waterCount
                    };
                  })
                  .where((e) {
                    if (e['date'] == null) return false;
                    final waterCount = e['water_count'] is int
                        ? e['water_count'] as int
                        : int.tryParse(e['water_count']?.toString() ?? '');
                    return waterCount != null && waterCount >= 8;
                  })
                  .toList();
                  // 2. sort by date ASC
                  validEntries.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
                  // 3. นับ streak เฉพาะวันที่ติดกัน ถ้าขาดวัน streak จะ reset เป็น 0
                  int waterStreak = 0;
                  DateTime? lastDate;
                  bool broken = false;
                  for (int i = 0; i < validEntries.length; i++) {
                    final currentDate = validEntries[i]['date'] as DateTime;
                    if (lastDate == null) {
                      waterStreak = 1;
                    } else if (currentDate.difference(lastDate).inDays == 1) {
                      waterStreak++;
                    } else {
                      // ขาดวัน streak ต้อง reset เป็น 0
                      waterStreak = 1;
                      broken = true;
                    }
                    lastDate = currentDate;
                  }
                  // ถ้ามีการขาดวัน streak ให้แสดง 0 (reset)
                  if (broken) waterStreak = 0;

                  // Exercise streak calculation (robust)
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('daily_exercise').snapshots(),
                    builder: (context, exerciseSnapshot) {
                      if (!exerciseSnapshot.hasData) return const CircularProgressIndicator();
                      final exerciseDocs = exerciseSnapshot.data!.docs;
                      // Filter เฉพาะ doc id ที่เป็นวันที่ (yyyy-MM-dd)
                      final validEntries = exerciseDocs.map((doc) {
                        DateTime? date;
                        try {
                          date = DateTime.parse(doc.id);
                        } catch (_) {
                          date = null;
                        }
                        return date;
                      }).where((d) => d != null).cast<DateTime>().toList();
                      validEntries.sort();
                      int exerciseStreak = 0;
                      int maxExerciseStreak = 0;
                      DateTime? lastDate;
                      for (final d in validEntries) {
                        if (lastDate == null) {
                          exerciseStreak = 1;
                        } else if (d.difference(lastDate).inDays == 1) {
                          exerciseStreak++;
                        } else {
                          exerciseStreak = 1;
                        }
                        lastDate = d;
                        if (exerciseStreak > maxExerciseStreak) maxExerciseStreak = exerciseStreak;
                      }

                      // Combined Card UI
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 26)),
                                  const SizedBox(width: 10),
                                  const Text('Current Streaks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text('💧', style: TextStyle(fontSize: 22)),
                                      const SizedBox(width: 6),
                                      const Text('Water', style: TextStyle(fontSize: 15)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('$waterStreak', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
                                      const SizedBox(width: 2),
                                      const Text('days', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.directions_run, color: Colors.orange, size: 22),
                                      const SizedBox(width: 6),
                                      const Text('Exercise', style: TextStyle(fontSize: 15)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('$exerciseStreak', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 20)),
                                      const SizedBox(width: 2),
                                      const Text('days', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // --- Current Streak: Water Intake ---
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('daily_data').orderBy('updatedAt').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final docs = snapshot.data!.docs;
                  int streak = 0;
                  int maxStreak = 0;
                  for (final doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final waterIntake = data['water_intake'];
                    if (waterIntake is int && waterIntake >= 8) {
                      streak++;
                      if (streak > maxStreak) maxStreak = streak;
                    } else {
                      streak = 0;
                    }
                  }
                  // Removed old water streak card below the combined streak card
                  return const SizedBox.shrink();
                },
              ),      // --- Daily Summary (water, sleep, exercise) ---

              // ...removed old water streak, sleep, and exercise summary cards...
            ],
          ),
        ),
      ),
    );
  }
}
