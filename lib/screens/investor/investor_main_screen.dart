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
    BrowseProjects(), // Browse Projects
    NotificationsScreen(), // Notifications
    InvestorProfile(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 70, // Adjust the height for a modern look
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3), // Glassmorphism effect with transparency
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ), // Rounded corners for a wavy effect
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -3), // Shadow above the navbar
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
onTap: (index) async {
  await Future.delayed(Duration(milliseconds: 100)); // Simulate animation delay
  setState(() {
    _currentIndex = index;
  });
},
          selectedItemColor: const Color(0xFF065A94), // Medium blue for selected items
          unselectedItemColor: const Color(0xFF49AEEF), // Light blue for unselected items
          backgroundColor: Colors.transparent, // Transparent background for glassmorphism
          type: BottomNavigationBarType.fixed,
          elevation: 0, // Remove default shadow
          showSelectedLabels: true,
          showUnselectedLabels: true,
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
              icon: Stack(
                children: [
                  Icon(Icons.notifications), // Use notifications icon
                  if (_hasNewNotifications()) // Add a red dot for new notifications
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person), // Use person icon for Profile
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // Function to check if there are new notifications
  bool _hasNewNotifications() {
    // Replace this with actual logic to check for new notifications in Firestore
    return true; // Example: Assume there are new notifications
  }
}