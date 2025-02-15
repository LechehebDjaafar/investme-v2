import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<String> notifications = [
    'Project "Project 1" has been accepted.',
    'New message from Investor 1.',
    'Project "Project 2" status changed to Pending.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(notifications[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Delete the notification
                },
              ),
            ),
          );
        },
      ),
    );
  }
}