import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // Dark blue background
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text
          ),
        ),
        backgroundColor: const Color(0xFF1E2A47), // Dark blue background
        elevation: 0, // Remove shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 5, // Example notification count
          itemBuilder: (context, index) {
            return _buildNotificationCard();
          },
        ),
      ),
    );
  }

  // Build a notification card
  Widget _buildNotificationCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white.withOpacity(0.1), // Semi-transparent white
      child: ListTile(
        leading: Icon(Icons.notifications, color: Colors.white70), // Notification icon
        title: Text(
          'New Investment Opportunity',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white, // White text
          ),
        ),
        subtitle: Text(
          'You have a new investment opportunity in the Technology sector.',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white70, // Light gray text
          ),
        ),
        trailing: Text(
          '10 min ago',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white70, // Light gray text
          ),
        ),
      ),
    );
  }
}