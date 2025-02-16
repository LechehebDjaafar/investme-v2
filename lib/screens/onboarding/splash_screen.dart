import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Function to check authentication and redirect accordingly
    Future<void> checkAuthentication(BuildContext context) async {
      await Future.delayed(Duration(seconds: 2)); // Display the splash screen for 2 seconds

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is logged in, fetch their role from Firestore
        try {
          DocumentSnapshot userDoc =
              await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

          if (userDoc.exists) {
            String role = userDoc['role'] ?? 'Unknown';

            // Redirect based on the user's role
            if (role == 'Investor') {
              context.go('/investor/main');
            } else if (role == 'Entrepreneur') {
              context.go('/entrepreneur/main');
            } else {
              // If the role is unknown, go to login screen
              context.go('/login');
            }
          } else {
            // If user data is not found, go to login screen
            context.go('/login');
          }
        } catch (e) {
          // Handle errors and go to login screen
          print('Error fetching user data: $e');
          context.go('/login');
        }
      } else {
        // User is not logged in, go to login screen
        context.go('/');
      }
    }

    // Call the function when building the widget
    checkAuthentication(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // Dark blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo (replace with your actual logo asset)
            // Image.asset(
            //   'assets/logo.png',
            //   width: 150,
            //   height: 150,
            // ),
            // const SizedBox(height: 20),
            // App title
            Text(
              'InvestMe',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 20),
            // Welcome message
            Text(
              'Welcome to the platform for investors and entrepreneurs!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white70, // Light gray text
              ),
            ),
            const SizedBox(height: 40),
            // Create Account button
            ElevatedButton(
              onPressed: () {
                context.go('/onboarding/name'); // Navigate to account creation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4B400), // Gold button
                foregroundColor: Colors.white, // White text
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
            // Log In button
            TextButton(
              onPressed: () {
                context.go('/login'); // Navigate to login screen
              },
              child: Text(
                'Log In',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: const Color(0xFFF4B400), // Gold text
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