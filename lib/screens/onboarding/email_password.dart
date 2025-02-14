import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class EmailPasswordScreen extends StatefulWidget {
  final String userRole; // الدور المختار (مستثمر أو رائد أعمال)

  const EmailPasswordScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  _EmailPasswordScreenState createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _createAccount(BuildContext context) {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      // الانتقال إلى الصفحة الرئيسية مع تمرير الدور المختار
      context.go('/home', extra: widget.userRole);
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
              "Create your account",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white, // نص أبيض
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Enter your email and create a password to complete registration.",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70, // نص رمادي فاتح
              ),
            ),
            const SizedBox(height: 40),
            // حقل البريد الإلكتروني
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white), // نص أبيض
              decoration: InputDecoration(
                labelText: "Email",
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
            // حقل كلمة المرور
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white), // نص أبيض
              decoration: InputDecoration(
                labelText: "Password",
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
            // زر إنشاء الحساب
            ElevatedButton(
              onPressed: () => _createAccount(context),
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
          ],
        ),
      ),
    );
  }
}