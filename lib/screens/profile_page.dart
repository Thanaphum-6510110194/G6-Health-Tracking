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
                color: Colors.blue[900],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: 1 / 5, // Changed to 1 / 5 for 5 steps
                    backgroundColor: Colors.grey[300],
                    color: Colors.blue[700],
                    minHeight: 4,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Step 1 of 5', // Changed to Step 1 of 5
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
                      border: Border.all(color: Colors.blue, width: 2),
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
                      color: Colors.blue[700],
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Date of Birth Text Field
            TextField(
              controller: _dateOfBirthController,
              readOnly: true, // Make it read-only so date picker is used
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: 'mm/dd/yyyy',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
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
              shrinkWrap: true, // To make GridView take only necessary space
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5, // Adjust as needed for button size
              children: [
                _buildGenderButton('Male', 'male', '😔'), // Using emoji for placeholder
                _buildGenderButton('Female', 'female', '😊'),
                _buildGenderButton('Non-binary', 'non-binary', '⚥'), // Unicode symbol
                _buildGenderButton('Prefer not to say', 'prefer-not-to-say', '❓'),
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
                  backgroundColor: Colors.blue[800], // Darker blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next', // Changed text to just "Next"
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

  Widget _buildGenderButton(String text, String value, String emoji) {
    bool isSelected = _selectedGender == value;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGender = value;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[100] : Colors.grey[100], // Light blue if selected, light grey otherwise
        foregroundColor: isSelected ? Colors.blue[800] : Colors.grey[700], // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300, // Blue border if selected
            width: 1.5,
          ),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24), // Adjust emoji size
          ),
          const SizedBox(width: 8),
          Flexible( // Use Flexible to prevent text overflow
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