import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import สำหรับ FilteringTextInputFormatter
import 'package:provider/provider.dart';
import '../providers/auth_notifier.dart';
import 'about_yourself.dart'; // เพิ่ม import สำหรับ AboutYourselfScreen

class PhysicalInfoScreen extends StatefulWidget {
  const PhysicalInfoScreen({super.key});

  @override
  State<PhysicalInfoScreen> createState() => _PhysicalInfoScreenState();
}

class _PhysicalInfoScreenState extends State<PhysicalInfoScreen> {
  // Load physical info from provider (Firestore)
  Future<void> _loadPhysicalInfoFromProvider() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    await authNotifier.fetchPhysicalInfo();
    final data = authNotifier.physicalInfoData;
    if (data != null) {
      setState(() {
        _weightController.text = data['weight']?.toString() ?? '';
        _heightController.text = data['height']?.toString() ?? '';
        _selectedActivityLevel = data['activityLevel'];
      });
    }
  }

  // Save physical info to provider (Firestore)
  Future<void> _savePhysicalInfoToProvider() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    try {
      await authNotifier.savePhysicalInfo(
        weight: _weightController.text,
        height: _heightController.text,
        activityLevel: _selectedActivityLevel,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving physical info: $e')),
      );
    }
  }
  final TextEditingController _weightController = TextEditingController(); // เพิ่ม Controller สำหรับน้ำหนัก
  final TextEditingController _heightController = TextEditingController(); // เพิ่ม Controller สำหรับส่วนสูง
  String? _selectedActivityLevel; // ระดับกิจกรรมที่เลือก

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPhysicalInfoFromProvider();
    });
  }

  @override
  void dispose() {
    _weightController.dispose(); // ต้อง dispose controller เมื่อ widget ถูกทำลาย
    _heightController.dispose(); // ต้อง dispose controller เมื่อ widget ถูกทำลาย
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0ABAB5)),
          onPressed: () {
            // ย้อนกลับไปหน้า ProfileScreen (Step 1)
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Physical Info',
              style: const TextStyle(
                color: Color(0xFF0ABAB5),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 2 / 5, // Step 2 of 5
                      backgroundColor: Colors.grey[300],
                      color: const Color(0xFF0ABAB5),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Step 2 of 5', // แสดง Step 2 of 5
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Weight and Height Section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight (kg)', // ระบุหน่วย kg ตรงๆ
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Weight Input Field
                      TextField(
                        controller: _weightController, // เชื่อม Controller
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly // อนุญาตเฉพาะตัวเลข
                        ],
                        decoration: InputDecoration(
                          hintText: '60', // ตัวอย่างน้ำหนักเป็น kg
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFF0ABAB5), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        ),
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Height (cm)', // ระบุหน่วย cm ตรงๆ
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Height Input Field
                      TextField(
                        controller: _heightController, // เชื่อม Controller
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: '170', // ตัวอย่างส่วนสูงเป็น cm
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFF0ABAB5), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        ),
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Activity Level Section
            Text(
              'Activity Level',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityLevelCard(
              'Sedentary',
              'Little to no exercise',
              Icons.chair,
              'sedentary',
            ),
            const SizedBox(height: 16),
            _buildActivityLevelCard(
              'Lightly Active',
              'Light exercise 1-3 days/week',
              Icons.emoji_emotions_sharp,
              'lightly_active',
            ),
            const SizedBox(height: 16),
            _buildActivityLevelCard(
              'Moderately Active',
              'Moderate exercise 3-5 days/week',
              Icons.directions_run,
              'moderately_active',
            ),
            const SizedBox(height: 16),
            _buildActivityLevelCard(
              'Very Active',
              'Hard exercise 6-7 days/week',
              Icons.fitness_center,
              'very_active',
            ),
            const SizedBox(height: 48),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: InkWell(
                onTap: () {
                  // Validate selection before navigating
                  if (_weightController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your weight.')),
                    );
                    return;
                  }
                  if (_heightController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your height.')),
                    );
                    return;
                  }
                  if (_selectedActivityLevel == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select your activity level.')),
                    );
                    return;
                  }

                  // Save physical info using provider
                  _savePhysicalInfoToProvider();
                  // Navigate to AboutYourselfScreen if all conditions are met
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutYourselfScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0ABAB5), // เริ่มต้น
                        Color(0xFF56DFCF), // สิ้นสุด
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0ABAB5).withAlpha((255 * 0.4).round()),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget สำหรับสร้าง Card ระดับกิจกรรม
  Widget _buildActivityLevelCard(String title, String subtitle, IconData icon, String value) {
    bool isSelected = _selectedActivityLevel == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedActivityLevel = value;
        });
      },
      child: Card(
        color: isSelected ? const Color(0xFFE0F7FA) : Colors.white, // พื้นหลังเมื่อเลือก/ไม่เลือก
        elevation: isSelected ? 4 : 2, // เงาเมื่อเลือก
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 36,
                color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[600],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
