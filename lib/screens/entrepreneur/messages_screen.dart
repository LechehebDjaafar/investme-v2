import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  final List<Map<String, String>> messages = [
    {'sender': 'Investor 1', 'lastMessage': 'Hello, I am interested in your project.'},
    {'sender': 'Investor 2', 'lastMessage': 'Can we discuss the details?'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(message['sender']!),
              subtitle: Text(message['lastMessage']!),
              onTap: () {
                // Navigate to Chat Screen
                Navigator.pushNamed(context, '/entrepreneur/chat', arguments: message);
              },
            ),
          );
        },
      ),
    );
  }
}