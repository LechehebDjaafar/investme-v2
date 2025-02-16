import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'investor_dashboard.dart';
import 'investor_profile.dart';

class InvestorMainScreen extends StatefulWidget {
  const InvestorMainScreen({Key? key}) : super(key: key);

  @override
  _InvestorMainScreenState createState() => _InvestorMainScreenState();
}

class _InvestorMainScreenState extends State<InvestorMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
     InvestorDashboard(), // Home
     Center(child: Text('Messages')), // Messages
     Center(child: Text('Notifications')), // Notifications
     InvestorProfile(), // Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
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