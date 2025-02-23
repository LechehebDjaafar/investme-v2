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
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      // الانتقال إلى شاشة اختيار العمر والجنس مع تمرير الاسم الأول والأخير
      context.go(
        '/onboarding/age-gender',
        extra: {'firstName': firstName, 'lastName': lastName},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your first and last name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // خلفية بيضاء
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        // زر العودة
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: const Color(0xFF032D64)), // أزرق داكن
                onPressed: () {
                      context.go('/splash'); // العودة إلى صفحة العمر والجنس // الرجوع إلى الصفحة السابقة
                },
              ),
            ),
            const SizedBox(height: 20),
            // عنوان الصفحة
            Text(
              "What's your name?",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF032D64), // أزرق داكن
              ),
            ),
            const SizedBox(height: 20),
            // حقل إدخال الاسم الأول
            TextField(
              controller: _firstNameController,
              style: TextStyle(color: const Color(0xFF032D64)), // نص أزرق داكن
              decoration: InputDecoration(
                labelText: "First Name",
                labelStyle: TextStyle(color: const Color(0xFF49AEEF)), // أزرق فاتح
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFFE8F1FA)), // حدود زرقاء فاتحة
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF065A94)), // حدود زرقاء متوسطة
                ),
              ),
            ),
            const SizedBox(height: 15),
            // حقل إدخال الاسم الأخير
            TextField(
              controller: _lastNameController,
              style: TextStyle(color: const Color(0xFF032D64)), // نص أزرق داكن
              decoration: InputDecoration(
                labelText: "Last Name",
                labelStyle: TextStyle(color: const Color(0xFF49AEEF)), // أزرق فاتح
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFFE8F1FA)), // حدود زرقاء فاتحة
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF065A94)), // حدود زرقاء متوسطة
                ),
              ),
            ),
            const SizedBox(height: 30),
            // زر الاستمرار
            Center(
              child: ElevatedButton(
                onPressed: () => _goToNextStep(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF065A94), // زر أزرق متوسط
                  foregroundColor: Colors.white, // نص أبيض
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Continue",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}