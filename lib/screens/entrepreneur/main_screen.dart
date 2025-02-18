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
        selectedItemColor: const Color(0xFFF4B400), // برتقالي مشرق
        unselectedItemColor: const Color(0xFF888888), // رمادي
        backgroundColor: const Color(0xFF1E2A47), // أزرق داكن
        type: BottomNavigationBarType.fixed,
        elevation: 8, // ظل خفيف
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 26), // زيادة حجم الأيقونة
            label: 'Home',
            activeIcon: Icon(Icons.home, size: 28, color: Color(0xFFF4B400)), // أيقونة محددة أكبر
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 26),
            label: 'Messages',
            activeIcon: Icon(Icons.message, size: 28, color: Color(0xFFF4B400)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 26),
            label: 'Notifications',
            activeIcon: Icon(Icons.notifications, size: 28, color: Color(0xFFF4B400)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 26),
            label: 'Profile',
            activeIcon: Icon(Icons.person, size: 28, color: Color(0xFFF4B400)),
          ),
        ],
      ),
    );
  }
}