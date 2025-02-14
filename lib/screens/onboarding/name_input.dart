import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class NameInputScreen extends StatefulWidget {
  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void _goToNextStep(BuildContext context) {
    if (_firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty) {
      // الانتقال إلى شاشة العمر والجنس باستخدام GoRouter
      context.go('/onboarding/age-gender');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // خلفية أزرق داكن
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What's your name?",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // نص أبيض
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              style: TextStyle(color: Colors.white), // نص أبيض
              decoration: InputDecoration(
                labelText: "First Name",
                labelStyle: TextStyle(color: Colors.white70), // نص رمادي فاتح
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54), // حدود رمادية
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF4A90E2)), // حدود زرقاء فاتحة
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _lastNameController,
              style: TextStyle(color: Colors.white), // نص أبيض
              decoration: InputDecoration(
                labelText: "Last Name",
                labelStyle: TextStyle(color: Colors.white70), // نص رمادي فاتح
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54), // حدود رمادية
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF4A90E2)), // حدود زرقاء فاتحة
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => _goToNextStep(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4B400), // زر ذهبي
                  foregroundColor: Colors.white, // نص أبيض
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}