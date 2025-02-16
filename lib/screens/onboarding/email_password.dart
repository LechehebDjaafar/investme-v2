import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailPasswordScreen extends StatefulWidget {
  final String userRole; // الدور المختار (Investor أو Entrepreneur)
  final String firstName; // الاسم الأول
  final String lastName; // الاسم الأخير
  final DateTime dateOfBirth; // تاريخ الميلاد
  final String gender; // الجنس

  const EmailPasswordScreen({
    Key? key,
    required this.userRole,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
  }) : super(key: key);

  @override
  _EmailPasswordScreenState createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase services
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _createAccount(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    try {
      // Step 1: Create the user account using Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Get the user ID
      String userId = userCredential.user!.uid;

      // Step 3: Create a new document for the user in Firestore
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'firstName': widget.firstName, // First name
        'lastName': widget.lastName, // Last name
        'age': calculateAge(widget.dateOfBirth), // Age based on date of birth
        'gender': widget.gender, // Gender
        'email': email, // Email
        'role': widget.userRole, // Role selected by the user
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Step 4: Redirect to the appropriate screen based on the user's role
      if (widget.userRole == 'Investor') {
        context.go('/investor/main', extra: {'name': '${widget.firstName} ${widget.lastName}'});
      } else if (widget.userRole == 'Entrepreneur') {
        context.go('/entrepreneur/main', extra: {'name': '${widget.firstName} ${widget.lastName}'});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown user role')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The password provided is too weak')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The account already exists for that email')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.message}')),
        );
      }
    } catch (e) {
      // Handle other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  // Calculate age based on date of birth
  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // Dark blue background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              "Create your account",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Enter your email and create a password to complete registration.",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70, // Light gray text
              ),
            ),
            const SizedBox(height: 40),
            // Email field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white), // White text
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white70), // Light gray text
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54), // Gray border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF4A90E2)), // Light blue border
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white), // White text
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white70), // Light gray text
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54), // Gray border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF4A90E2)), // Light blue border
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Create Account button
            ElevatedButton(
              onPressed: () => _createAccount(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4B400), // Gold button
                foregroundColor: Colors.white, // White text
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Create Account",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}