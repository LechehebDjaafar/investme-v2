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
      backgroundColor: const Color(0xFF1E2A47), // خلفية أزرق داكن
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              "Choose your role",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white, // نص أبيض
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Are you an investor or an entrepreneur?",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70, // نص رمادي فاتح
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
                backgroundColor: const Color(0xFFF4B400), // زر ذهبي
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
          color: selectedRole == role ? const Color(0xFFF4B400) : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selectedRole == role ? const Color(0xFFF4B400) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: selectedRole == role ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 10),
            Text(
              role,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: selectedRole == role ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}