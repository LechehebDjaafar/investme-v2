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
      backgroundColor: const Color(0xFFFFFFFF), // خلفية بيضاء
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        // زر العودة
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: const Color(0xFF032D64)), // أزرق داكن
                onPressed: () {
                  context.go('/onboarding/name'); // العودة إلى صفحة العمر والجنس // الرجوع إلى الصفحة السابقة
                },
              ),
            ),
            // const SizedBox(height: 20),
            const SizedBox(height: 20),
            // عنوان الصفحة
            Text(
              "Tell us about yourself",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF032D64), // أزرق داكن
              ),
            ),
            const SizedBox(height: 10),
            // وصف الصفحة
            Text(
              "Select your date of birth and gender to continue",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF49AEEF), // أزرق فاتح
              ),
            ),
            const SizedBox(height: 40),
            // حقل اختيار تاريخ الميلاد
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE8F1FA)), // حدود زرقاء فاتحة
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
                        color: selectedDate == null
                            ? const Color(0xFF49AEEF) // أزرق فاتح
                            : const Color(0xFF032D64), // أزرق داكن
                        fontSize: 16,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: const Color(0xFF49AEEF)), // أيقونة زرقاء فاتحة
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
          color: selectedGender == gender
              ? const Color(0xFF065A94) // زر أزرق متوسط عند الاختيار
              : const Color(0xFFF5F5F5), // خلفية رمادية فاتحة عند عدم الاختيار
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selectedGender == gender
                ? const Color(0xFF065A94) // حدود زرقاء متوسطة عند الاختيار
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: selectedGender == gender
                  ? Colors.white // أيقونة بيضاء عند الاختيار
                  : const Color(0xFF032D64), // أيقونة زرقاء داكنة عند عدم الاختيار
            ),
            const SizedBox(height: 5),
            Text(
              gender,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: selectedGender == gender
                    ? Colors.white // نص أبيض عند الاختيار
                    : const Color(0xFF032D64), // نص زرقاء داكنة عند عدم الاختيار
              ),
            ),
          ],
        ),
      ),
    );
  }
}