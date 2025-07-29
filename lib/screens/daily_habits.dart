import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- Model Class for Exercise Activity ---
class ExerciseActivity {
  String id;
  String name;
  TimeOfDay scheduledTime;
  Duration goalDuration;
  Duration remainingDuration;
  bool isRunning = false;
  Timer? timer;

  ExerciseActivity({
    required this.name,
    required this.scheduledTime,
    required this.goalDuration,
  })  : id = UniqueKey().toString(),
        remainingDuration = goalDuration;
}


// กำหนดค่าสีหลักตามที่คุณต้องการ
const Color primaryColor = Color(0xFF0ABAB5);
const Color gradientColor = Color(0xFF56DFCF);
const Color textColor = Color(0xFF000000);
const Color textOnButtonColor = Color(0xFFFFFFFF);
const Color cardBackgroundColor = Colors.white;
const Color screenBackgroundColor = Color(0xFFF0F4F8);
const Color secondaryTextColor = Colors.grey;

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'Inter', // แนะนำให้ใช้ฟอนต์ที่ดูสะอาดตา
        scaffoldBackgroundColor: screenBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: textColor),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // --- ส่วนหัว ---
            const Text(
              'Daily Habits',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track your wellness journey',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 32),

            // --- การ์ดแสดงผล ---
            const WaterIntakeCard(),
            const SizedBox(height: 20),
            const ExerciseCard(),
            const SizedBox(height: 20),
            const SleepCard(),
          ],
        ),
      ),
    );
  }
}

// --- Widget สำหรับการ์ดดื่มน้ำ ---
class WaterIntakeCard extends StatefulWidget {
  const WaterIntakeCard({super.key});

  @override
  State<WaterIntakeCard> createState() => _WaterIntakeCardState();
}

class _WaterIntakeCardState extends State<WaterIntakeCard> {
  int _waterCount = 0;

  void _addWater() {
    if (_waterCount < 8) {
      setState(() {
        _waterCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HabitCard(
      icon: Icons.water_drop,
      title: 'Water Intake',
      subtitle: '$_waterCount of 8 glasses',
      buttonText: '+ Add',
      onPressed: _addWater,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(8, (index) {
          return Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: index < _waterCount ? primaryColor : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}

// --- Widget สำหรับการ์ดออกกำลังกาย (Refactored to handle a list of activities) ---
class ExerciseCard extends StatefulWidget {
  const ExerciseCard({super.key});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  final List<ExerciseActivity> _activities = [];
  String? _expandedActivityId;

  @override
  void dispose() {
    for (var activity in _activities) {
      activity.timer?.cancel();
    }
    super.dispose();
  }

  void _toggleTimer(ExerciseActivity activity) {
    if (activity.isRunning) {
      activity.timer?.cancel();
    } else {
      if (activity.remainingDuration.inSeconds > 0) {
        activity.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            if (activity.remainingDuration.inSeconds > 0) {
              setState(() {
                activity.remainingDuration -= const Duration(seconds: 1);
              });
            } else {
              timer.cancel();
              setState(() {
                activity.isRunning = false;
              });
            }
          } else {
            timer.cancel();
          }
        });
      }
    }
    setState(() {
      activity.isRunning = !activity.isRunning;
    });
  }

  void _resetTimer(ExerciseActivity activity) {
    activity.timer?.cancel();
    setState(() {
      activity.isRunning = false;
      activity.remainingDuration = activity.goalDuration;
    });
  }
  
  void _deleteActivity(String id) {
     final activity = _activities.firstWhere((act) => act.id == id);
     activity.timer?.cancel();
     setState(() {
       _activities.removeWhere((act) => act.id == id);
     });
  }

  Future<void> _showActivityDialog({ExerciseActivity? activity}) async {
    final bool isEditing = activity != null;
    final nameController = TextEditingController(text: activity?.name ?? '');
    TimeOfDay selectedTime = activity?.scheduledTime ?? TimeOfDay.now();
    Duration selectedDuration = activity?.goalDuration ?? const Duration(minutes: 10);


    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Activity' : 'Add Activity'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Activity Name'), autofocus: true),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Duration'),
                      subtitle: Text('${selectedDuration.inHours}h ${selectedDuration.inMinutes.remainder(60)}m ${selectedDuration.inSeconds.remainder(60)}s'),
                      trailing: const Icon(Icons.timer_outlined),
                      onTap: () async {
                        final Duration? picked = await showDialog<Duration>(
                          context: context,
                          builder: (context) {
                            Duration tempDuration = selectedDuration;
                            return AlertDialog(
                              title: const Text('Select Duration'),
                              content: SizedBox(
                                height: 200,
                                child: CupertinoTimerPicker(
                                  mode: CupertinoTimerPickerMode.hms,
                                  initialTimerDuration: tempDuration,
                                  onTimerDurationChanged: (Duration newDuration) {
                                    tempDuration = newDuration;
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(tempDuration),
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDuration = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Start Time'),
                      subtitle: Text(selectedTime.format(context)),
                      trailing: const Icon(Icons.schedule),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(context: context, initialTime: selectedTime);
                        if (picked != null && picked != selectedTime) {
                          setDialogState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    final name = nameController.text;
                    if (name.isNotEmpty && selectedDuration.inSeconds > 0) {
                      Navigator.of(context).pop({
                        'name': name,
                        'duration': selectedDuration,
                        'time': selectedTime,
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        if (isEditing) {
          activity.name = result['name'];
          activity.goalDuration = result['duration'];
          activity.scheduledTime = result['time'];
          _resetTimer(activity);
        } else {
          _activities.add(ExerciseActivity(
            name: result['name'],
            goalDuration: result['duration'],
            scheduledTime: result['time'],
          ));
        }
      });
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return HabitCard(
      icon: Icons.directions_run,
      title: 'Exercise',
      subtitle: '${_activities.length} activities planned',
      buttonText: '+ Add',
      onPressed: () => _showActivityDialog(),
      child: _activities.isEmpty
          ? const Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('No activities added yet.', style: TextStyle(color: secondaryTextColor)),
          ))
          : ExpansionPanelList.radio(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              initialOpenPanelValue: _expandedActivityId,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  if (_expandedActivityId == _activities[index].id) {
                    _expandedActivityId = null;
                  } else {
                    _expandedActivityId = _activities[index].id;
                  }
                });
              },
              children: _activities.map<ExpansionPanelRadio>((activity) {
                return ExpansionPanelRadio(
                  value: activity.id,
                  backgroundColor: cardBackgroundColor,
                  canTapOnHeader: true,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(activity.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(activity.scheduledTime.format(context), style: const TextStyle(color: secondaryTextColor, fontSize: 14)),
                    );
                  },
                  body: _buildExpandedActivityBody(activity),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildExpandedActivityBody(ExerciseActivity activity) {
    final bool isFinished = activity.remainingDuration.inSeconds == 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Text(
            _formatDuration(activity.remainingDuration),
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: isFinished ? Colors.green : textColor, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: const Icon(Icons.edit, color: secondaryTextColor), onPressed: () => _showActivityDialog(activity: activity)),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: isFinished ? () => _resetTimer(activity) : () => _toggleTimer(activity),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activity.isRunning ? Colors.redAccent : (isFinished ? Colors.grey : primaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(isFinished ? 'Reset' : (activity.isRunning ? 'Stop' : 'Start'), style: const TextStyle(color: textOnButtonColor, fontSize: 16)),
                ),
              ),
              IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => _deleteActivity(activity.id)),
            ],
          ),
        ],
      ),
    );
  }
}


// --- Widget สำหรับการ์ดนอนหลับ (Stateful with sleep calculation) ---
class SleepCard extends StatefulWidget {
  const SleepCard({super.key});

  @override
  State<SleepCard> createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard> {
  Duration _sleepDuration = Duration.zero;
  int _starCount = 0;

  String _formatSleepDuration(Duration d) {
    if (d == Duration.zero) return 'No sleep logged';
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '${hours}h ${minutes}m last night';
  }

  int _calculateStars(Duration duration) {
    final hours = duration.inHours;
    if (hours >= 8) return 5;
    if (hours >= 6) return 4;
    if (hours >= 5) return 3;
    if (hours >= 3) return 2;
    if (hours > 0) return 1;
    return 0;
  }

  Future<void> _showSleepLogDialog() async {
    TimeOfDay? bedTime = const TimeOfDay(hour: 22, minute: 0);
    TimeOfDay? wakeTime = const TimeOfDay(hour: 6, minute: 0);

    final result = await showDialog<Map<String, TimeOfDay>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Log Your Sleep'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Bedtime'),
                  subtitle: Text(bedTime!.format(context)),
                  trailing: const Icon(Icons.nightlight_round),
                  onTap: () async {
                    final picked = await showTimePicker(context: context, initialTime: bedTime!);
                    if (picked != null) {
                      setDialogState(() => bedTime = picked);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Wake-up Time'),
                  subtitle: Text(wakeTime!.format(context)),
                  trailing: const Icon(Icons.wb_sunny),
                  onTap: () async {
                    final picked = await showTimePicker(context: context, initialTime: wakeTime!);
                    if (picked != null) {
                      setDialogState(() => wakeTime = picked);
                    }
                  },
                )
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop({'bedTime': bedTime!, 'wakeTime': wakeTime!});
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );

    if (result != null) {
      final bed = result['bedTime']!;
      final wake = result['wakeTime']!;
      
      final now = DateTime.now();
      DateTime bedDateTime = DateTime(now.year, now.month, now.day, bed.hour, bed.minute);
      DateTime wakeDateTime = DateTime(now.year, now.month, now.day, wake.hour, wake.minute);

      if (wakeDateTime.isBefore(bedDateTime) || wakeDateTime.isAtSameMomentAs(bedDateTime)) {
        wakeDateTime = wakeDateTime.add(const Duration(days: 1));
      }

      setState(() {
        _sleepDuration = wakeDateTime.difference(bedDateTime);
        _starCount = _calculateStars(_sleepDuration);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HabitCard(
      icon: Icons.bedtime,
      title: 'Sleep',
      subtitle: _formatSleepDuration(_sleepDuration),
      buttonText: 'Update', // This button is part of the original design, we keep it but it does nothing.
      onPressed: () {}, // Or you can have it call _showSleepLogDialog as well.
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quality', style: TextStyle(fontSize: 16, color: textColor)),
                Row(children: List.generate(5, (index) {
                  return Icon(
                    index < _starCount ? Icons.star : Icons.star_border,
                    color: Colors.amber.shade400,
                    size: 24,
                  );
                })),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showSleepLogDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Log Sleep', style: TextStyle(color: textOnButtonColor, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}

// --- Widget การ์ดหลัก (Reusable) ---
class HabitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final Widget child;
  final VoidCallback? onPressed;

  const HabitCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [primaryColor, gradientColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: textOnButtonColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: secondaryTextColor)),
                  ],
                ),
              ),
              TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(buttonText, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
