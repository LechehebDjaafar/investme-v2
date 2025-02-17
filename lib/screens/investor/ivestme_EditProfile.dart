import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  String? _gender; // Gender field

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _firstNameController = TextEditingController(text: userData['firstName']);
        _lastNameController = TextEditingController(text: userData['lastName']);
        _emailController = TextEditingController(text: userData['email']);
        _bioController = TextEditingController(text: userData['bio'] ?? '');
        _gender = userData['gender'] ?? 'Male'; // Default to 'Male' if not set
      });
    }
  }

  void _updateUserProfile() async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String bio = _bioController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Update user data in Firestore
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'bio': bio,
        'gender': _gender, // Update gender
      });

      // Update email in Firebase Authentication
      await _auth.currentUser!.updateEmail(email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context); // Go back to the profile screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FA), // Updated light blue background
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
        ),
        backgroundColor: const Color(0xFFE8F1FA), // Light blue app bar
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture (Optional)
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://thumbs.dreamstime.com/b/modern-real-estate-investment-logo-design-vector-property-growing-commercial-economic-338365420.jpg'), // Replace with actual image URL
                    backgroundColor: Colors.transparent,
                  ),
                  IconButton(
                    onPressed: () {
                      // Add logic to upload or change profile picture
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Change profile picture')));
                    },
                    icon: Icon(Icons.edit, color: Color(0xFF065A94)), // Medium blue icon
                    tooltip: 'Edit Profile Picture',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input Fields
            TextField(
              controller: _firstNameController,
              style: TextStyle(color: Color(0xFF032D64)),
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Color(0xFF49AEEF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1F87D2).withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF065A94)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _lastNameController,
              style: TextStyle(color: Color(0xFF032D64)),
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Color(0xFF49AEEF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1F87D2).withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF065A94)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Color(0xFF032D64)),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Color(0xFF49AEEF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1F87D2).withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF065A94)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _bioController,
              maxLines: 3,
              style: TextStyle(color: Color(0xFF032D64)),
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(color: Color(0xFF49AEEF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1F87D2).withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF065A94)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gender',
                  style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF032D64)),
                ),
                DropdownButton<String>(
                  value: _gender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                  items: ['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.poppins(color: Color(0xFF49AEEF)),
                      ),
                    );
                  }).toList(),
                  dropdownColor: Color(0xFFE8F1FA),
                  underline: Container(
                    height: 2,
                    color: Color(0xFF1F87D2).withOpacity(0.5),
                  ),
                  style: GoogleFonts.poppins(color: Color(0xFF032D64)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                // Cancel Button
ElevatedButton(
  onPressed: () {
    Navigator.pop(context); // Go back without saving changes
  },
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Color(0xFF49AEEF),
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    shadowColor: Colors.black.withOpacity(0.2),
    elevation: 4,
  ),
  child: Text(
    'Cancel',
    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
  ),
),

                // Save Changes Button
                ElevatedButton(
                  onPressed: _updateUserProfile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF065A94),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black.withOpacity(0.2),
                    elevation: 4,
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}