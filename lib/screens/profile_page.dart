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
              primary: const Color(0xFF00CAFF), // สีฟ้าอ่อนสำหรับ Header ของ DatePicker
              onPrimary: Colors.white,         // สีของตัวอักษรใน Header
              surface: Colors.white,           // สีพื้นหลังของ DatePicker
              onSurface: Colors.black,         // สีของตัวอักษรวันที่
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00CAFF), // สีของปุ่ม "CANCEL" และ "OK" ใน DatePicker
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
                color: const Color(0xFF3B5998), // สีหัวข้อ
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
                      color: const Color(0xFF00CAFF), // สี Progress Bar
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
                      color: Colors.blue[50], // Light blue background
                      border: Border.all(color: const Color(0xFF00CAFF), width: 2), // สีขอบเป็นฟ้าอ่อน
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: Colors.blue[300],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Profile Photo',
                    style: TextStyle(
                      color: const Color(0xFF00CAFF), // สีข้อความ "Add Profile Photo"
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Full Name Text Field
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(
                  color: Colors.grey[700], // สีของ Label Text
                ),
                floatingLabelStyle: const TextStyle(
                  color: Color(0xFF00CAFF), // สีของ Label Text เมื่อโฟกัส
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
                    color: Color(0xFF00CAFF), // สีขอบ TextField เมื่อโฟกัส
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
                  color: Color(0xFF00CAFF), // สีของ Label Text เมื่อโฟกัส
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
                    color: Color(0xFF00CAFF), // สีขอบ TextField เมื่อโฟกัส
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
            const SizedBox(height: 24),

            // Gender Section
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
                _buildGenderButton('Not specified', 'not-specified', Icons.help_outline), // เปลี่ยนกลับเป็น Prefer not to say
              ],
            ),
            const SizedBox(height: 48),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement navigation to the next step
                  print('Full Name: ${_fullNameController.text}');
                  print('Date of Birth: ${_dateOfBirthController.text}');
                  print('Selected Gender: $_selectedGender');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Next button tapped!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00CAFF), // สีของปุ่ม Next
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
        foregroundColor: isSelected ? const Color(0xFF007BFF) : Colors.grey[700], // Text/Icon color เมื่อเลือก (ฟ้าเข้ม)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? const Color(0xFF00CAFF) : Colors.grey.shade300!, // สีขอบเมื่อเลือก (ฟ้าอ่อน)
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
            color: isSelected ? const Color(0xFF007BFF) : Colors.grey[700], // สี Icon
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