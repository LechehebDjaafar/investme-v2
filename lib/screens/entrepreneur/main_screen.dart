import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../onboarding/splash_screen.dart';
import 'dashboard.dart';
import 'messages_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainStateManager createState() => _MainStateManager();
}

class _MainStateManager extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    DashboardScreen(),
    MessagesScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If no user is logged in, redirect to splash screen
    if (user == null) {
      return SplashScreen(); // Redirect to splash screen
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFF4B400),
        unselectedItemColor: const Color(0xFF888888),
        backgroundColor: const Color(0xFF1E2A47),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}