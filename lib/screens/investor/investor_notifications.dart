import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FA), // Updated light blue background
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF032D64), // Updated text color
          ),
        ),
        backgroundColor: const Color(0xFFE8F1FA), // Updated app bar background
        elevation: 0, // Remove shadow
        actions: [
          IconButton(
            onPressed: () {
              // Clear all notifications logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All notifications cleared')),
              );
            },
            icon: Icon(Icons.clear_all, color: const Color(0xFF032D64)), // Updated icon color
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 5, // Example notification count
          itemBuilder: (context, index) {
            bool isRead = index % 2 == 0; // Example: Alternate read/unread status

            return Dismissible(
              key: Key(index.toString()),
              onDismissed: (direction) {
                // Remove notification logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notification dismissed')),
                );
              },
              background: Container(
                color: Colors.red.withOpacity(0.2), // Background when swiping to dismiss
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.red), // Delete icon
              ),
              child: _buildNotificationCard(isRead,context),
            );
          },
        ),
      ),
    );
  }

  // Build a notification card
  Widget _buildNotificationCard(bool isRead,context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: isRead ? const Color(0xFF1F87D2).withOpacity(0.1) : const Color(0xFF065A94).withOpacity(0.2), // Updated card colors
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded corners
      child: ListTile(
        leading: Icon(
          Icons.notifications,
          color: isRead ? const Color(0xFF49AEEF) : Colors.white, // Updated icon color
        ),
        title: Text(
          'New Investment Opportunity',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: isRead ? const Color(0xFF49AEEF) : Colors.white, // Updated text color
          ),
        ),
        subtitle: Text(
          'You have a new investment opportunity in the Technology sector.',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF49AEEF), // Updated text color
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isRead)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red, // Red dot for unread notifications
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: 10),
            Text(
              '10 min ago',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF49AEEF), // Updated text color
              ),
            ),
          ],
        ),
        onTap: () {
          // Mark notification as read and navigate to details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notification marked as read')),
          );
        },
      ),
    );
  }
}