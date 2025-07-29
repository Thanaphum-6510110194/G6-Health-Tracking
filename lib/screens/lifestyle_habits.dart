import 'package:flutter/material.dart';

class LifestyleHabitsScreen extends StatefulWidget {
  const LifestyleHabitsScreen({super.key});

  @override
  State<LifestyleHabitsScreen> createState() => _LifestyleHabitsScreenState();
}

class _LifestyleHabitsScreenState extends State<LifestyleHabitsScreen> {
  String? _selectedSleepDuration;
  String? _selectedWaterIntake;
  String? _selectedStressLevel;

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
            Navigator.pop(context); // ย้อนกลับไปหน้า AboutYourselfScreen
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lifestyle Habits',
              style: TextStyle(
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
                      value: 4 / 5, // Step 4 of 5
                      backgroundColor: Colors.grey[300],
                      color: const Color(0xFF0ABAB5),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Step 4 of 5', // แสดง Step 4 of 5
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
            Text(
              'How many hours do you typically sleep?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.9, // ปรับค่านี้ให้เล็กลงเพื่อทำให้ปุ่มสูงขึ้น (ใหญ่ขึ้น)
              children: [
                _buildOptionCard('Less than 6', 'Not enough', 'less_than_6', _selectedSleepDuration, (value) {
                  setState(() {
                    _selectedSleepDuration = value;
                  });
                }),
                _buildOptionCard('6-7 hours', 'Below average', '6-7_hours', _selectedSleepDuration, (value) {
                  setState(() {
                    _selectedSleepDuration = value;
                  });
                }),
                _buildOptionCard('7-8 hours', 'Recommended', '7-8_hours', _selectedSleepDuration, (value) {
                  setState(() {
                    _selectedSleepDuration = value;
                  });
                }),
                _buildOptionCard('8+ hours', 'Well rested', '8_plus_hours', _selectedSleepDuration, (value) {
                  setState(() {
                    _selectedSleepDuration = value;
                  });
                }),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              'How much water do you drink daily?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8, // ปรับค่านี้ให้เล็กลงเพื่อทำให้ปุ่มสูงขึ้น (ใหญ่ขึ้น)
              children: [
                _buildOptionCard('1-3 glasses', 'Need more', '1-3_glasses', _selectedWaterIntake, (value) {
                  setState(() {
                    _selectedWaterIntake = value;
                  });
                }),
                _buildOptionCard('4-6 glasses', 'Getting there', '4-6_glasses', _selectedWaterIntake, (value) {
                  setState(() {
                    _selectedWaterIntake = value;
                  });
                }),
                _buildOptionCard('7-8 glasses', 'Good amount', '7-8_glasses', _selectedWaterIntake, (value) {
                  setState(() {
                    _selectedWaterIntake = value;
                  });
                }),
                _buildOptionCard('8+ glasses', 'Well hydrated', '8_plus_glasses', _selectedWaterIntake, (value) {
                  setState(() {
                    _selectedWaterIntake = value;
                  });
                }),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              'How would you rate your stress levels?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStressLevelOption('Very Low', 'very_low', Icons.sentiment_satisfied_alt, Colors.green),
                _buildStressLevelOption('Low', 'low', Icons.sentiment_satisfied, Colors.lightGreen),
                _buildStressLevelOption('Moderate', 'moderate', Icons.sentiment_neutral, Colors.orange),
                _buildStressLevelOption('High', 'high', Icons.sentiment_dissatisfied, Colors.deepOrange),
                _buildStressLevelOption('Very High', 'very_high', Icons.sentiment_very_dissatisfied, Colors.red),
              ],
            ),
            const SizedBox(height: 24),

            // Next Button with Gradient
            SizedBox(
              width: double.infinity,
              height: 56,
              child: InkWell(
                onTap: () {
                  // Validate selections before navigating
                  if (_selectedSleepDuration == null ||
                      _selectedWaterIntake == null ||
                      _selectedStressLevel == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all lifestyle habits fields.')),
                    );
                    return;
                  }
                  // TODO: Navigate to the next screen (e.g., GoalConfirmationScreen or SummaryScreen)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Next: Lifestyle Habits completed!')),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const NextScreenAfterLifestyle()),
                  // );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0ABAB5), // Start
                        Color(0xFF56DFCF), // End
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
                    'Next: Confirm Goals',
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

  // Widget สำหรับสร้าง Card ตัวเลือกทั่วไป (Sleep, Water)
  Widget _buildOptionCard(String title, String subtitle, String value, String? selectedValue, ValueChanged<String> onChanged) {
    bool isSelected = selectedValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Card(
        color: isSelected ? const Color(0xFFE0F7FA) : Colors.white,
        elevation: isSelected ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สำหรับสร้างตัวเลือก Stress Level
  Widget _buildStressLevelOption(String label, String value, IconData icon, Color color) {
    bool isSelected = _selectedStressLevel == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStressLevel = value;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 36,
              color: isSelected ? color : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? color : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
