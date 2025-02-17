import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation; // Animation for the logo
  late Animation<double> _textAnimation; // Animation for the text

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Total animation duration (2 seconds)
    );
    // Define animations
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.75, curve: Curves.easeInOut)), // Logo appears in the first 1.5 seconds
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.75, 1.0, curve: Curves.easeInOut)), // Text appears in the last 0.5 seconds
    );
    // Start the animation when the screen is loaded
    _controller.forward();

    // Check authentication after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 500), () {
          checkAuthentication(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  // Function to check authentication and redirect accordingly
  Future<void> checkAuthentication(BuildContext context) async {
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
            context.go('/splash');
          }
        } else {
          // If user data is not found, go to login screen
          context.go('/splash');
        }
      } catch (e) {
        // Handle errors and go to login screen
        print('Error fetching user data: $e');
        context.go('/splash');
      }
    } else {
      // User is not logged in, go to login screen
      context.go('/splash');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            FadeTransition(
              opacity: _logoAnimation, // Use the logo animation
              child: Image.asset(
                'assets/logo.jpg', // Replace with your logo file path
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
            // Animated App Name
            FadeTransition(
              
              opacity: _textAnimation, // Use the text animation
              child: Text(
                'InvestMe',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF032D64), // Dark blue text
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}