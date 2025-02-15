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

  // خدمة Firebase
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
      // إنشاء الحساب باستخدام Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // الحصول على ID المستخدم
      String userId = userCredential.user!.uid;

      // إنشاء مستند جديد للمستخدم في Firestore
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'firstName': widget.firstName, // الاسم الأول
        'lastName': widget.lastName, // الاسم الأخير
        'age': calculateAge(widget.dateOfBirth), // العمر بناءً على تاريخ الميلاد
        'gender': widget.gender, // الجنس
        'email': email, // البريد الإلكتروني
        'role': widget.userRole, // الدور المختار
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // الانتقال إلى الصفحة الرئيسية بناءً على الدور
      context.go('/main', extra: {'role': widget.userRole, 'name': '${widget.firstName} ${widget.lastName}'});
    } on FirebaseAuthException catch (e) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  // حساب العمر بناءً على تاريخ الميلاد
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