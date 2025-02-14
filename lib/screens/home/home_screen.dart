import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final String? userRole; // دور المستخدم
  final String? userName; // اسم المستخدم

  const HomeScreen({Key? key, this.userRole, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "InvestMe",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4A90E2), // أزرق فاتح
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome, ${userName ?? 'User'}!",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // نص أبيض
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                userRole == "Investor"
                    ? "Explore promising startups and invest in the future!"
                    : "Find investors and grow your business!",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70, // نص رمادي فاتح
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // زر اكتشاف المشاريع أو البحث عن مستثمرين
              ElevatedButton(
                onPressed: () {
                  // يمكنك تحديد الصفحة بناءً على الدور
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4B400), // زر ذهبي
                  foregroundColor: Colors.white, // نص أبيض
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  userRole == "Investor" ? "Discover Startups" : "Find Investors",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}