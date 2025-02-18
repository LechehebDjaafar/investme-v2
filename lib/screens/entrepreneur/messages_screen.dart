import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F0FE), // خلفية عامة
      appBar: AppBar(
        backgroundColor: Color(0xFF2196F3), // أزرق داكن غني
        title: Text('Messages', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message_outlined,
                size: 64,
                color: Color(0xFF42A5F5), // أزرق متوسط فاتح
              ),
              SizedBox(height: 16),
              Text(
                'No messages yet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E), // أزرق داكن غني
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This section will be used to communicate with investors.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF616161), // رمادي داكن
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}