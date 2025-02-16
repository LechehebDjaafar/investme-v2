import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EntrepreneurProfile extends StatelessWidget {
  final String entrepreneurId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EntrepreneurProfile({required this.entrepreneurId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47),
      appBar: AppBar(
        title: Text(
          'Entrepreneur Profile',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E2A47),
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(entrepreneurId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Entrepreneur not found', style: TextStyle(color: Colors.white)));
          }

          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData['profilePicture'] ?? 'default_image_url'),
                ),
                const SizedBox(height: 20),
                Text(
                  '${userData['firstName']} ${userData['lastName']}',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  userData['email'],
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add chat logic here
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFFF4B400),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Contact Entrepreneur',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}