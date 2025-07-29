import 'package:flutter/material.dart';

class AboutYourselfScreen extends StatefulWidget {
  const AboutYourselfScreen({super.key});

  @override
  State<AboutYourselfScreen> createState() => _AboutYourselfScreenState();
}

class _AboutYourselfScreenState extends State<AboutYourselfScreen> {
  String? _selectedHealthDescription;
  String? _selectedHealthGoal;

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
            Navigator.pop(context); // ย้อนกลับไปหน้า PhysicalInfoScreen
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Yourself',
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
                      value: 3 / 5, // Step 3 of 5 (เปลี่ยนจาก 6 เป็น 5)
                      backgroundColor: Colors.grey[300],
                      color: const Color(0xFF0ABAB5),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Step 3 of 5', // แสดง Step 3 of 5 (เปลี่ยนจาก 6 เป็น 5)
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
              'How would you describe your current health?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHealthDescriptionOption('Poor', 'poor', Icons.sentiment_dissatisfied, Colors.red),
                _buildHealthDescriptionOption('Fair', 'fair', Icons.sentiment_neutral, Colors.orange),
                _buildHealthDescriptionOption('Good', 'good', Icons.sentiment_satisfied, Colors.blue),
                _buildHealthDescriptionOption('Great', 'great', Icons.sentiment_very_satisfied, Colors.green),
                _buildHealthDescriptionOption('Excellent', 'excellent', Icons.star, Colors.purple),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'What\'s your primary health goal?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            _buildHealthGoalOption('Lose Weight', 'lose_weight', Icons.scale),
            const SizedBox(height: 16),
            _buildHealthGoalOption('Build Muscle', 'build_muscle', Icons.fitness_center),
            const SizedBox(height: 16),
            _buildHealthGoalOption('Improve Fitness', 'improve_fitness', Icons.run_circle),
            const SizedBox(height: 16),
            _buildHealthGoalOption('Better Sleep', 'better_sleep', Icons.bedtime),
            const SizedBox(height: 16),
            _buildHealthGoalOption('Reduce Stress', 'reduce_stress', Icons.self_improvement),
            const SizedBox(height: 16),
            _buildHealthGoalOption('Eat Healthier', 'eat_healthier', Icons.restaurant),
            const SizedBox(height: 40),

            // Next Button with Gradient
            SizedBox(
              width: double.infinity,
              height: 56,
              child: InkWell(
                onTap: () {
                  // Validate selections before navigating
                  if (_selectedHealthDescription == null || _selectedHealthGoal == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select both health description and primary goal.')),
                    );
                    return;
                  }
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
                    'Next: Set Your Goals',
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

  Widget _buildHealthDescriptionOption(String label, String value, IconData icon, Color color) {
    bool isSelected = _selectedHealthDescription == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedHealthDescription = value;
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

  Widget _buildHealthGoalOption(String label, String value, IconData icon) {
    bool isSelected = _selectedHealthGoal == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedHealthGoal = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: isSelected ? const Color(0xFFE0F7FA) : Colors.white, // สีพื้นหลัง
        elevation: isSelected ? 4 : 2, // เงาเมื่อเลือก/ไม่เลือก
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // ปรับ borderRadius ให้เป็น 16 เพื่อให้เหมือน Card ทั่วไป
          side: BorderSide(
            color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey.shade300, // สีขอบ
            width: isSelected ? 2 : 1, // ความหนาขอบ
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[700],
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
