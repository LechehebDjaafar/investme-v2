import 'package:flutter/material.dart';
import 'investor_dashboard.dart';
import 'browse_projects.dart';
import 'investor_notifications.dart';
import 'investor_profile.dart';

class InvestorMainScreen extends StatefulWidget {
  @override
  _InvestorMainScreenState createState() => _InvestorMainScreenState();
}

class _InvestorMainScreenState extends State<InvestorMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    InvestorDashboard(), // Home
    BrowseProjects(), // Messages (Browse Projects)
    NotificationsScreen(), // Notifications (Project Details)
    InvestorProfile(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFF4B400), // Gold for selected items
        unselectedItemColor: const Color(0xFF888888), // Gray for unselected items
        backgroundColor: const Color(0xFF1E2A47), // Dark blue background
        type: BottomNavigationBarType.fixed, // Fixed type for multiple items
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // Use search icon for Browse Projects
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications), // Use notifications icon
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Use person icon for Profile
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}