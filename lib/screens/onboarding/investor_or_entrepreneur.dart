import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class InvestorOrEntrepreneurScreen extends StatefulWidget {
  final String firstName; // الاسم الأول
  final String lastName; // الاسم الأخير
  final DateTime dateOfBirth; // تاريخ الميلاد
  final String gender; // الجنس

  const InvestorOrEntrepreneurScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
  }) : super(key: key);

  @override
  _InvestorOrEntrepreneurScreenState createState() =>
      _InvestorOrEntrepreneurScreenState();
}

class _InvestorOrEntrepreneurScreenState
    extends State<InvestorOrEntrepreneurScreen> {
  String? selectedRole; // الدور المختار (Investor أو Entrepreneur)

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
                      context.go('/onboarding/age-gender'); // العودة إلى صفحة العمر والجنس // الرجوع إلى الصفحة السابقة
                },
              ),
            ),
            // const SizedBox(height: 20),
            const SizedBox(height: 20),
            // عنوان الصفحة
            Text(
              "Choose your role",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF032D64), // أزرق داكن
              ),
            ),
            const SizedBox(height: 10),
            // وصف الصفحة
            Text(
              "Are you an investor or an entrepreneur?",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF49AEEF), // أزرق فاتح
              ),
            ),
            const SizedBox(height: 40),
            // زر اختيار دور المستثمر
            _buildRoleButton("Investor", Icons.trending_up),
            const SizedBox(height: 20),
            // زر اختيار دور رائد الأعمال
            _buildRoleButton("Entrepreneur", Icons.business_center),
            const Spacer(),
            // زر إنشاء الحساب
            ElevatedButton(
              onPressed: () {
                if (selectedRole != null) {
                  // الانتقال إلى شاشة إنشاء الحساب مع تمرير جميع البيانات
                  context.go(
                    '/onboarding/email-password',
                    extra: {
                      'userRole': selectedRole,
                      'firstName': widget.firstName, // الاسم الأول
                      'lastName': widget.lastName, // الاسم الأخير
                      'dateOfBirth': widget.dateOfBirth, // تاريخ الميلاد
                      'gender': widget.gender, // الجنس
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please choose a role')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF065A94), // زر أزرق متوسط
                foregroundColor: Colors.white, // نص أبيض
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // زر اختيار الدور
  Widget _buildRoleButton(String role, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: selectedRole == role
              ? const Color(0xFF065A94) // زر أزرق متوسط عند الاختيار
              : const Color(0xFFF5F5F5), // خلفية رمادية فاتحة عند عدم الاختيار
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selectedRole == role
                ? const Color(0xFF065A94) // حدود زرقاء متوسطة عند الاختيار
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: selectedRole == role
                  ? Colors.white // أيقونة بيضاء عند الاختيار
                  : const Color(0xFF032D64), // أيقونة زرقاء داكنة عند عدم الاختيار
            ),
            const SizedBox(width: 10),
            Text(
              role,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: selectedRole == role
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