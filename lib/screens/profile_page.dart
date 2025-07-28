import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this for date formatting

class BasicProfileScreen extends StatefulWidget {
  const BasicProfileScreen({super.key});

  @override
  State<BasicProfileScreen> createState() => _BasicProfileScreenState();
}

class _BasicProfileScreenState extends State<BasicProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  String? _selectedGender; // To store the selected gender

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF0ABAB5), // สีสำหรับ Header ของ DatePicker (เปลี่ยนเป็น 0ABAB5)
              onPrimary: Colors.white, // สีของตัวอักษรใน Header
              surface: Colors.white, // สีพื้นหลังของ DatePicker
              onSurface: Colors.black, // สีของตัวอักษรวันที่
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0ABAB5), // สีของปุ่ม "CANCEL" และ "OK" ใน DatePicker (เปลี่ยนเป็น 0ABAB5)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ตั้งค่าสีพื้นหลังของ Scaffold เป็นสีขาว
      appBar: AppBar(
        toolbarHeight: 80, // Adjust toolbar height as needed
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Profile',
              style: TextStyle(
                color: const Color(0xFF0ABAB5), // สีหัวข้อ (เปลี่ยนเป็น 0ABAB5)
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // กำหนดรัศมีโค้งมน
                    child: LinearProgressIndicator(
                      value: 1 / 5, // Changed to 1 / 5 for 5 steps
                      backgroundColor: Colors.grey[300],
                      color: const Color(0xFF0ABAB5), // สี Progress Bar (เปลี่ยนเป็น 0ABAB5)
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Step 1 of 5',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Profile Picture Section
            GestureDetector(
              onTap: () {
                // TODO: Implement image picking logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Profile Photo tapped! (Not implemented yet)')),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0ABAB5), width: 2), // สีขอบเป็น 0ABAB5
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Profile Photo',
                    style: TextStyle(
                      color: const Color(0xFF0ABAB5), // สีข้อความ "Add Profile Photo" (เปลี่ยนเป็น 0ABAB5)
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Full Name และ Date of Birth ใน Card
            Card(
              color: Colors.white,
              elevation: 4, // เพิ่มเงา
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // ขอบโค้งมน
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin รอบ Card
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Padding ภายใน Card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Text Field
                    TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                          color: Colors.grey[700], // สีของ Label Text
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF0ABAB5), // สีของ Label Text เมื่อโฟกัส (เปลี่ยนเป็น 0ABAB5)
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400!, // สีขอบ TextField ปกติ
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0ABAB5), // สีขอบ TextField เมื่อโฟกัส (เปลี่ยนเป็น 0ABAB5)
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400!, // สีขอบ TextField เมื่อไม่ได้โฟกัส
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      style: const TextStyle(color: Colors.black87), // สีของข้อความที่กรอก
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth Text Field
                    TextField(
                      controller: _dateOfBirthController,
                      readOnly: true, // Make it read-only so date picker is used
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        labelText: 'mm/dd/yyyy',
                        labelStyle: TextStyle(
                          color: Colors.grey[700], // สีของ Label Text
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF0ABAB5), // สีของ Label Text เมื่อโฟกัส (เปลี่ยนเป็น 0ABAB5)
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400!, // สีขอบ TextField ปกติ
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0ABAB5), // สีขอบ TextField เมื่อโฟกัส (เปลี่ยนเป็น 0ABAB5)
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400!, // สีขอบ TextField เมื่อไม่ได้โฟกัส
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                          color: Colors.grey[600], // สี Icon ของปฏิทิน
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      style: const TextStyle(color: Colors.black87), // สีของข้อความที่กรอก
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Gender Section ใน Card
            Card(
              color: Colors.white,
              elevation: 4, // เพิ่มเงา
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // ขอบโค้งมน
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin รอบ Card
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Padding ภายใน Card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Gender',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                      children: [
                        _buildGenderButton('Male', 'male', Icons.male),
                        _buildGenderButton('Female', 'female', Icons.female),
                        _buildGenderButton('Non-binary', 'non-binary', Icons.transgender),
                        _buildGenderButton('Prefer not to say', 'prefer-not-to-say', Icons.help_outline),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Next Button พร้อม Gradient
            SizedBox(
              width: double.infinity,
              height: 56,
              child: InkWell(
                onTap: () {
                  // TODO: Implement navigation to the next step
                  print('Full Name: ${_fullNameController.text}');
                  print('Date of Birth: ${_dateOfBirthController.text}');
                  print('Selected Gender: $_selectedGender');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Next button tapped!')),
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
                        color: const Color(0xFF0ABAB5).withOpacity(0.4),
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

  Widget _buildGenderButton(String text, String value, IconData iconData) {
    bool isSelected = _selectedGender == value;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGender = value;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFE0F7FA) : Colors.grey[100], // Background color เมื่อเลือก (ฟ้าอ่อนมาก)
        foregroundColor: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[700], // Text/Icon color เมื่อเลือก (เปลี่ยนเป็น 0ABAB5)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey.shade300!, // สีขอบเมื่อเลือก (เปลี่ยนเป็น 0ABAB5)
            width: 1.5,
          ),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 24,
            color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[700], // สี Icon (เปลี่ยนเป็น 0ABAB5)
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}