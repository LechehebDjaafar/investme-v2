import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // فحص حالة تسجيل الدخول عند بناء الشاشة
    Future<void> checkAuthentication() async {
      await Future.delayed(Duration(seconds: 1)); // عرض الشاشة لمدة ثانيتين
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // إذا كان المستخدم مسجل دخول، الانتقال إلى MainScreen
        context.go('/main');
      } else {
        // إذا لم يكن المستخدم مسجل دخول، عرض الخيارات
        context.go('/'); // البقاء في الشاشة نفسها أو الانتقال إلى صفحة الترحيب
      }
    }

    // تشغيل فحص التسجيل عند بناء الشاشة
    checkAuthentication();

    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // خلفية أزرق داكن
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // // شعار InvestMe
            // Image.asset(
            //   'assets/logo.png', // استبدل هذا المسار بشعار التطبيق الخاص بك
            //   width: 150,
            //   height: 150,
            // ),
            // const SizedBox(height: 20),

            // عنوان InvestMe
            Text(
              'InvestMe',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white, // نص أبيض
              ),
            ),
            const SizedBox(height: 20),

            // نص ترحيبي
            Text(
              'Welcome to the platform for investors and entrepreneurs!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white70, // نص رمادي فاتح
              ),
            ),
            const SizedBox(height: 40),

            // زر إنشاء الحساب
            ElevatedButton(
              onPressed: () {
                context.go('/onboarding/name'); // الانتقال إلى شاشة إنشاء الحساب
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
                'Create Account',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),

            // زر تسجيل الدخول
            TextButton(
              onPressed: () {
                context.go('/login'); // الانتقال إلى شاشة تسجيل الدخول
              },
              child: Text(
                'Log In',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: const Color(0xFFF4B400), // نص ذهبي
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}