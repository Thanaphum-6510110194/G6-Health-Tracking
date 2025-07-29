import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images from camera/gallery
import 'dart:io'; // For File operations

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _imageFile;
  String? _message;

  static const Color _primaryColor = Color(0xFF0ABAB5);
  static const Color _secondaryColor = Color(0xFF56DFCF);

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _message = null; // Clear previous messages
    });
    try {
      // Use the image_picker to get an image
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        // If a file was picked, update the state with the new image file
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        // If no file was picked (e.g., user cancelled)
        setState(() {
          _message = 'Image selection cancelled.';
        });
      }
    } catch (e) {
      // Handle any errors during image picking
      setState(() {
        _message = 'Error picking image: $e';
      });
      print('Error picking image: $e'); // Print error to console for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Apply a gradient background similar to the React app
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryColor, _secondaryColor.withValues(alpha: 0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Title and icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt, size: 36, color: _primaryColor),
                        SizedBox(width: 10),
                        Text(
                          'Capture Your Meal',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Display selected image or placeholder
                    _imageFile == null
                        ? Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _secondaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              // Corrected: Removed invalid BorderStyle.dashed
                              border: Border.all(color: _primaryColor, width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: _primaryColor,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No image selected yet.',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _imageFile!,
                              height: 300,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.red[100],
                                  child: Center(
                                    child: Text('Error loading image: $error'),
                                  ),
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 30),

                    // Message display
                    if (_message != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          _message!,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Buttons to pick image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Take Photo'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor, // Button color
                              foregroundColor: Colors.white, // Text color
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              elevation: 5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('from Gallery'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor, // Button color
                              foregroundColor: Colors.white, // Text color
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              elevation: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}