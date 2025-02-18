import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // White background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo (replace with your actual logo asset)
            Image.asset(
              'assets/logo.jpg',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // App title
            Text(
              'InvestMe',
              style: GoogleFonts.poppins(
                fontSize: 36, // Adjusted size for better balance
                fontWeight: FontWeight.bold,
                color: const Color(0xFF032D64), // Dark blue text
              ),
            ),
            const SizedBox(height: 10),
            // Welcome message
            Text(
              'Welcome to the platform for investors and entrepreneurs!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16, // Adjusted size for readability
                color: const Color(0xFF49AEEF), // Light blue text
              ),
            ),
            const SizedBox(height: 40),
            // Create Account button
            ElevatedButton(
              onPressed: () {
                context.go('/onboarding/name'); // Navigate to account creation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF065A94), // Medium blue button
                foregroundColor: Colors.white, // White text
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Create Account',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // White text
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Log In button
            TextButton(
              onPressed: () {
                context.go('/login'); // Navigate to login screen
              },
              child: Text(
                'Log In',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: const Color(0xFF00C853), // Green text for emphasis
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