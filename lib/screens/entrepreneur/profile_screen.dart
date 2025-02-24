import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // For base64 encoding/decoding

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
    'age': '', // Age
    'gender': '', // Gender
    'country': '', // Country
    'bio': '', // Bio
    'interests': '', // Interests
    'achievements': '', // Achievements
    'photoUrl': '', // This will store the Base64 string
  };

  bool _isEditing = false; // To toggle between view and edit modes
  File? _imageFile; // For storing the selected image

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController(); // Age
  final TextEditingController _genderController = TextEditingController(); // Gender
  final TextEditingController _countryController = TextEditingController(); // Country
  final TextEditingController _bioController = TextEditingController(); // Bio
  final TextEditingController _interestsController = TextEditingController(); // Interests
  final TextEditingController _achievementsController = TextEditingController(); // Achievements

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
    _ageController.text = _userProfile['age']?.toString() ?? '';
    _genderController.text = _userProfile['gender'] ?? '';
    _countryController.text = _userProfile['country'] ?? '';
    _bioController.text = _userProfile['bio'] ?? '';
    _interestsController.text = _userProfile['interests'] ?? '';
    _achievementsController.text = _userProfile['achievements'] ?? '';
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
        'age': int.tryParse(_ageController.text) ?? 0, // Age
        'gender': _genderController.text, // Gender
        'country': _countryController.text, // Country
        'bio': _bioController.text, // Bio
        'interests': _interestsController.text, // Interests
        'achievements': _achievementsController.text, // Achievements
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

  // Sign out function
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/splash'); // Navigate to splash screen after logout
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE), // خلفية عامة
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E), // أزرق داكن غني
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true; // الدخول إلى وضع التحرير
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.check, color: Colors.white),
              onPressed: _saveUserProfile,
            ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                _signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView( // استبدال Column بـ ListView
          children: [
            // صورة البروفايل
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera_alt, color: Color(0xFF42A5F5)),
                        title: Text('Take Photo', style: TextStyle(color: Color(0xFF1A237E))),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library, color: Color(0xFF42A5F5)),
                        title: Text('Choose from Gallery', style: TextStyle(color: Color(0xFF1A237E))),
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
                    ? MemoryImage(base64Decode(_userProfile['photoUrl']))
                    : AssetImage('assets/default_profile.png') as ImageProvider, // الصورة الافتراضية
                backgroundColor: Colors.grey.shade300,
              ),
            ),
            SizedBox(height: 20),

            // حقل الاسم
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.person, color: Color(0xFF42A5F5)),
              ),
              readOnly: !_isEditing,
            ),
            SizedBox(height: 10),

            // حقل العمر
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.cake, color: Color(0xFF42A5F5)),
              ),
              readOnly: !_isEditing,
            ),
            SizedBox(height: 10),

            // حقل الجنس
            TextFormField(
              controller: _genderController,
              decoration: InputDecoration(
                labelText: 'Gender',
                labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.transgender, color: Color(0xFF42A5F5)),
              ),
              readOnly: !_isEditing,
            ),
            SizedBox(height: 10),

            // حقل الدولة
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Country',
                labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.location_on, color: Color(0xFF42A5F5)),
              ),
              readOnly: !_isEditing,
            ),
            SizedBox(height: 10),

            // حقل السيرة الذاتية
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.description, color: Color(0xFF42A5F5)),
              ),
              readOnly: !_isEditing,
            ),
            SizedBox(height: 10),

            // حقل الاهتمامات
            TextFormField(
              controller: _interestsController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Interests',
                labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.favorite, color: Color(0xFF42A5F5)),
              ),
              readOnly: !_isEditing,
            ),
            SizedBox(height: 10),

            // حقل الإنجازات
            TextFormField(
              controller: _achievementsController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Achievements',
                labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.star, color: Color(0xFF42A5F5)),
              ),
              readOnly: !_isEditing,
            ),
          ],
        ),
      ),
    );
  }

}