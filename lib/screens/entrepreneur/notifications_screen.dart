import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F0FE), // خلفية عامة
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E), // أزرق داكن غني
        title: Text('Notifications', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.mark_email_unread, color: Colors.white), // أيقونة الرسائل غير المقروءة
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mark all notifications as read')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No notifications yet.\nStay tuned for updates!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final isRead = notification['isRead'] ?? false; // Check if the notification is read

                return NotificationTile(
                  title: notification['title'],
                  subtitle: notification['subtitle'],
                  timestamp: notification['timestamp'],
                  icon: getNotificationIcon(notification['type']),
                  isRead: isRead, // Pass the isRead status to the tile
                );
              },
            );
          },
        ),
      ),
    );
  }

  IconData getNotificationIcon(String? type) {
    switch (type) {
      case 'investment':
        return Icons.monetization_on;
      case 'post':
        return Icons.post_add;
      case 'project_accepted':
        return Icons.check_circle_outline;
      case 'project_rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications;
    }
  }
}

// Reusable notification tile component
class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timestamp;
  final IconData icon;
  final bool isRead; // Add a flag to indicate if the notification is read

  const NotificationTile({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isRead ? 10 : 15), // Round corners more for unread notifications
      ),
      elevation: isRead ? 4 : 8, // Higher elevation for unread notifications
      color: isRead ? null : Colors.blue.shade50, // Light background for unread notifications
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(
          icon,
          color: isRead ? Color(0xFF2196F3) : Colors.redAccent, // Change icon color for unread notifications
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isRead ? Color(0xFF1A237E) : Colors.redAccent, // Change text color for unread notifications
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: isRead ? Color(0xFF42A5F5) : Colors.redAccent, // Change subtitle color for unread notifications
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timestamp,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            if (!isRead) // Show a small dot for unread notifications
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}