import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // For base64 encoding/decoding
import 'dart:typed_data'; // For Uint8List

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Map<String, dynamic> _userProfile = {
    'name': '',
    'email': '',
    'bio': '',
    'photoUrl': '', // This will store the Base64 string
  };

  bool _isEditing = false; // To toggle between view and edit modes
  File? _imageFile; // For storing the selected image

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Fetch user profile data from Firestore
  Future<void> _fetchUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final docSnapshot = await _db.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        setState(() {
          _userProfile = docSnapshot.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }

    // Initialize controllers with current data
    _nameController.text = _userProfile['name'] ?? '';
    _bioController.text = _userProfile['bio'] ?? '';
  }

  // Save updated profile data to Firestore
  Future<void> _saveUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Update Firestore with new data
      await _db.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'email': user.email, // Email is read-only
        'bio': _bioController.text,
        'photoUrl': _userProfile['photoUrl'], // Update photoUrl if needed
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );

      setState(() {
        _isEditing = false; // Exit edit mode after saving
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  // Pick an image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload image to Firestore as Base64
      await _uploadImageToFirestore();
    }
  }

  // Convert image to Base64 and save it in Firestore
  Future<void> _uploadImageToFirestore() async {
    final user = _auth.currentUser;
    if (user == null || _imageFile == null) return;

    try {
      // Read the image file as bytes
      final bytes = await _imageFile!.readAsBytes();

      // Convert bytes to Base64 string
      final base64Image = base64Encode(bytes);

      // Save Base64 string in Firestore
      await _db.collection('users').doc(user.uid).update({'photoUrl': base64Image});

      setState(() {
        _userProfile['photoUrl'] = base64Image; // Update local state
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true; // Enter edit mode
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _saveUserProfile,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Take Photo'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Choose from Gallery'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _userProfile['photoUrl'] != null && _userProfile['photoUrl'].toString().isNotEmpty
                    ? MemoryImage(base64Decode(_userProfile['photoUrl'])) // Decode Base64 and display image
                    : AssetImage('assets/default_profile.png') as ImageProvider, // Default image
              ),
            ),
            SizedBox(height: 20),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
              readOnly: !_isEditing,
            ),
            SizedBox(height: 10),

            // Email Field (Read-Only)
            TextFormField(
              initialValue: _userProfile['email'],
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              readOnly: true,
            ),
            SizedBox(height: 10),

            // Bio Field
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                prefixIcon: Icon(Icons.description),
              ),
              readOnly: !_isEditing,
            ),
          ],
        ),
      ),
    );
  }
}