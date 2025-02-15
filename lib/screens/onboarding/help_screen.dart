import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Frequently Asked Questions (FAQs)
            Text(
              'Frequently Asked Questions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ExpansionTile(
              title: Text('How do I add a new project?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'To add a new project, go to the dashboard and click on the "+" icon.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How do I edit my profile?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'You can edit your profile by clicking on the "Edit" button in the top-right corner of the profile screen.',
                  ),
                ),
              ],
            ),

            // Contact Us Section
            SizedBox(height: 20),
            Text(
              'Contact Us:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Send a message to InvestMe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _sendMessage(context);
              },
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to send a message to InvestMe
  void _sendMessage(BuildContext context) {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    // TODO: Implement sending the message to InvestMe (e.g., via email or Firestore)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message sent successfully!')),
    );

    // Clear the text field after sending
    _messageController.clear();
  }
}