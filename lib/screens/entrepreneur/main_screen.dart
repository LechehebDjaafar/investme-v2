import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:investme/screens/entrepreneur/unified_page.dart';
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
    UnifiedPage(),
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
        selectedItemColor: const Color(0xFF42A5F5), // أزرق متوسط فاتح (بديل للبرتقالي)
        unselectedItemColor: const Color(0xFFBBDEFB), // أزرق فاتح جدًا (بديل للرمادي)
        backgroundColor: const Color(0xFF1A237E), // أزرق داكن غني (بديل للأزرق الداكن)
        type: BottomNavigationBarType.fixed,
        elevation: 8, // ظل خفيف
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 26), // زيادة حجم الأيقونة
            label: 'Home',
            activeIcon: Icon(Icons.home, size: 28, color: Color(0xFF42A5F5)), // أيقونة نشطة أكبر وأزرق متوسط فاتح
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 26),
            label: 'Messages',
            activeIcon: Icon(Icons.message, size: 28, color: Color(0xFF42A5F5)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 26),
            label: 'Notifications',
            activeIcon: Icon(Icons.notifications, size: 28, color: Color(0xFF42A5F5)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 26),
            label: 'Profile',
            activeIcon: Icon(Icons.person, size: 28, color: Color(0xFF42A5F5)),
          ),
        ],
      ),
    );
  }
}