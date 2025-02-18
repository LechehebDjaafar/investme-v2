import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FA), // Light blue background
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF032D64), // Dark blue text
          ),
        ),
        backgroundColor: const Color(0xFFE8F1FA), // Light blue app bar
        elevation: 0, // Remove shadow
        actions: [
          IconButton(
            onPressed: () async {
              // Clear all notifications logic here
              try {
                final user = _auth.currentUser;
                if (user != null) {
                  await _firestore.collection('users').doc(user.uid).update({
                    'notifications': [], // Clear notifications array
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All notifications cleared')),
                  );
                }
              } catch (e) {
                print('Error clearing notifications: $e');
              }
            },
            icon: Icon(Icons.clear_all, color: const Color(0xFF032D64)), // Updated icon color
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Text(
                'No notifications yet.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF49AEEF), // Light blue text
                ),
              ),
            );
          }

          List<Map<String, dynamic>> notifications = snapshot.data as List<Map<String, dynamic>>;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> notification = notifications[index];
              bool isRead = notification['isRead'] ?? false;

              return Dismissible(
                key: Key(notification['id'].toString()),
                onDismissed: (direction) async {
                  try {
                    final user = _auth.currentUser;
                    if (user != null) {
                      await _firestore.collection('users').doc(user.uid).update({
                        'notifications': FieldValue.arrayRemove([notification]),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notification dismissed')),
                      );
                    }
                  } catch (e) {
                    print('Error dismissing notification: $e');
                  }
                },
                background: Container(
                  color: Colors.red.withOpacity(0.2), // Background when swiping to dismiss
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.red), // Delete icon
                ),
                child: _buildNotificationCard(isRead, notification, context),
              );
            },
          );
        },
      ),
    );
  }

  // Fetch notifications for the current user
  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return [];

      List<dynamic> notifications = userDoc.data()?['notifications'] ?? [];
      return List<Map<String, dynamic>>.from(notifications);
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  // Build a notification card
  Widget _buildNotificationCard(bool isRead, Map<String, dynamic> notification, BuildContext context) {
    String projectName = notification['projectName'] ?? 'Unnamed Project';
    double investmentAmount = (notification['investmentAmount'] ?? 0).toDouble();

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
          'Investment in $projectName',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: isRead ? const Color(0xFF49AEEF) : Colors.white, // Updated text color
          ),
        ),
        subtitle: Text(
          'You invested \$${investmentAmount.toStringAsFixed(2)} in this project.',
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
              notification['timeAgo'] ?? 'Just now',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF49AEEF), // Updated text color
              ),
            ),
          ],
        ),
        onTap: () async {
          try {
            final user = _auth.currentUser;
            if (user != null) {
              await _firestore.collection('users').doc(user.uid).update({
                'notifications': FieldValue.arrayUnion([
                  {...notification, 'isRead': true}
                ]),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notification marked as read')),
              );
            }
          } catch (e) {
            print('Error marking notification as read: $e');
          }
        },
      ),
    );
  }
}