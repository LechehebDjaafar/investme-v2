import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F0FE), // خلفية عامة
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E), // أزرق داكن غني
        title: Text('Notifications', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 5, // Example: Display 5 notifications
          itemBuilder: (context, index) {
            return NotificationTile(
              title: 'Project Approved',
              subtitle: 'Your project "Eco App" has been approved!',
              timestamp: '3 hours ago',
            );
          },
        ),
      ),
    );
  }
}

// Reusable notification tile component
class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timestamp;

  const NotificationTile({
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // زوايا مستديرة
      ),
      elevation: 4, // ظل خفيف
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(
          Icons.notifications,
          color: Color(0xFF2196F3), // أزرق مشرق
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E), // أزرق داكن غني
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF42A5F5), // نصوص ثانوية
          ),
        ),
        trailing: Text(
          timestamp,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}