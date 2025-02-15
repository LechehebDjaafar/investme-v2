import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
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
      child: ListTile(
        leading: Icon(Icons.notifications, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(timestamp, style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}