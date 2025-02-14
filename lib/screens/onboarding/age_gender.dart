import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class AgeGenderScreen extends StatefulWidget {
  final String firstName; // الاسم الأول
  final String lastName; // الاسم الأخير

  const AgeGenderScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  _AgeGenderScreenState createState() => _AgeGenderScreenState();
}

class _AgeGenderScreenState extends State<AgeGenderScreen> {
  DateTime? selectedDate; // تاريخ الميلاد
  String? selectedGender; // الجنس

  // دالة لاختيار تاريخ الميلاد
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // خلفية أزرق داكن
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              "Tell us about yourself",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white, // نص أبيض
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Select your date of birth and gender to continue",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70, // نص رمادي فاتح
              ),
            ),
            const SizedBox(height: 40),
            // حقل اختيار تاريخ الميلاد
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "Select your date of birth"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: TextStyle(
                        color: selectedDate == null ? Colors.white70 : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Colors.white70),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // زر اختيار الجنس
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGenderButton("Male", Icons.male),
                _buildGenderButton("Female", Icons.female),
              ],
            ),
            const Spacer(),
            // زر الاستمرار
            ElevatedButton(
              onPressed: selectedDate != null && selectedGender != null
                  ? () {
                      // الانتقال إلى شاشة اختيار الدور مع تمرير جميع البيانات
                      context.go(
                        '/onboarding/role-selection',
                        extra: {
                          'firstName': widget.firstName,
                          'lastName': widget.lastName,
                          'dateOfBirth': selectedDate,
                          'gender': selectedGender,
                        },
                      );
                    }
                  : null, // عطل الزر إذا لم يتم اختيار التاريخ أو الجنس
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4B400), // زر ذهبي
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // زر اختيار الجنس
  Widget _buildGenderButton(String gender, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: selectedGender == gender ? const Color(0xFFF4B400) : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selectedGender == gender ? const Color(0xFFF4B400) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: selectedGender == gender ? Colors.white : Colors.black54,
            ),
            const SizedBox(height: 5),
            Text(
              gender,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: selectedGender == gender ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}