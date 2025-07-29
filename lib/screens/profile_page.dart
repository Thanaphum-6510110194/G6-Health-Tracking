import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io'; // For File
import 'package:image_picker/image_picker.dart'; // For picking images
import 'package:path_provider/path_provider.dart'; // For finding local path
import 'physical_info.dart'; // Import PhysicalInfoScreen
import 'login_screen.dart'; // Import LoginScreen

class BasicProfileScreen extends StatefulWidget {
  const BasicProfileScreen({super.key});

  @override
  State<BasicProfileScreen> createState() => _BasicProfileScreenState();
}

class _BasicProfileScreenState extends State<BasicProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  String? _selectedGender; // To store the selected gender

  File? _profileImageFile; // To store the selected image file locally

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data including locally saved image
  }

  // Function to load profile data (from SharedPreferences or Local Database)
  // and load image from saved path
  Future<void> _loadProfileData() async {
    // In a real app, you would load fullName, dateOfBirth, gender from SharedPreferences/Local DB
    // Example: SharedPreferences prefs = await SharedPreferences.getInstance();
    // _fullNameController.text = prefs.getString('fullName') ?? '';
    // _dateOfBirthController.text = prefs.getString('dateOfBirth') ?? '';
    // _selectedGender = prefs.getString('gender');

    // This part loads the profile picture stored locally
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/profile.png'; // Path where we store the image

      final File savedImage = File(imagePath);
      if (await savedImage.exists()) {
        setState(() {
          _profileImageFile = savedImage;
        });
      }
    } catch (e) {
      print('Error loading local profile image: $e');
      // You might show a SnackBar or log the error
    }
  }

  // Function to pick and save image locally
  Future<void> _pickAndSaveImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File pickedImage = File(pickedFile.path);

      try {
        final directory = await getApplicationDocumentsDirectory();
        final String imagePath = '${directory.path}/profile.png';

        // Save the image file to that directory
        final File savedImage = await pickedImage.copy(imagePath);

        setState(() {
          _profileImageFile = savedImage; // Update the displayed image file
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture saved locally!')),
          );
        }
      } catch (e) {
        print('Error saving image locally: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save profile picture locally: $e')),
          );
        }
      }
    }
  }

  // Function to delete profile image
  Future<void> _deleteProfileImage() async {
    if (_profileImageFile != null) {
      try {
        await _profileImageFile!.delete(); // Delete the image file
        setState(() {
          _profileImageFile = null; // Set to null to display the Icon instead
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture deleted!')),
          );
        }
      } catch (e) {
        print('Error deleting image locally: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete profile picture: $e')),
          );
        }
      }
    }
  }

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0ABAB5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0ABAB5),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0ABAB5)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Profile',
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
                      value: 1 / 5, // Step 1 of 5
                      backgroundColor: Colors.grey[300],
                      color: const Color(0xFF0ABAB5),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Step 1 of 5', // Display Step 1 of 5
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
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: _pickAndSaveImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[50],
                      border: Border.all(color: const Color(0xFF0ABAB5), width: 2),
                    ),
                    child: _profileImageFile != null
                        ? ClipOval(
                            child: Image.file(
                              _profileImageFile!,
                              key: ValueKey(_profileImageFile!.lastModifiedSync()),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 60,
                                color: Colors.blue[300],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  color: Colors.blue[300],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                if (_profileImageFile != null)
                  Positioned(
                    bottom: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120,
                          height: 1,
                          color: Colors.grey[400],
                        ),
                        GestureDetector(
                          onTap: _deleteProfileImage,
                          child: Container(
                            width: 120,
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha((255 * 0.8).round()),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(60),
                              ),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red[400],
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Full Name and Date of Birth in Card
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Text Field
                    TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF0ABAB5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0ABAB5),
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth Text Field
                    TextField(
                      controller: _dateOfBirthController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        labelText: 'mm/dd/yyyy',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF0ABAB5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF0ABAB5),
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                          color: Colors.grey[600],
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Gender Section in Card
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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

            // Next Button with Gradient
            SizedBox(
              width: double.infinity,
              height: 56,
              child: InkWell(
                onTap: () {
                  // *** เพิ่มการตรวจสอบเงื่อนไขที่นี่ ***
                  if (_fullNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your full name.')),
                    );
                    return;
                  }
                  if (_dateOfBirthController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select your date of birth.')),
                    );
                    return;
                  }
                  if (_selectedGender == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select your gender.')),
                    );
                    return;
                  }

                  // Navigate to PhysicalInfoScreen if all conditions are met
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PhysicalInfoScreen()),
                  );
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
        backgroundColor: isSelected ? const Color(0xFFE0F7FA) : Colors.grey[100],
        foregroundColor: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey.shade300, // ลบ ! ออก
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
            color: isSelected ? const Color(0xFF0ABAB5) : Colors.grey[700],
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
