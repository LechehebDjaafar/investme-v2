import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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

            // FAQ 1
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

            // FAQ 2
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

            // Message Input Field
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Send a message to InvestMe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                ElevatedButton(
                  onPressed: () {
                    context.go('/main'); // Go back to ProfileScreen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red for cancel
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                // Send Button
                ElevatedButton(
                  onPressed: () {
                    _sendMessage(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4B400), // Gold for send
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
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

    // Simulate sending the message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message sent successfully!')),
    );

    // Clear the text field after sending
    _messageController.clear();

    // Navigate to Dashboard after sending the message
    context.go('/main'); // Assuming '/main' is the route for MainScreen
  }
}