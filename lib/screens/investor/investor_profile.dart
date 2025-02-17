import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class InvestorProfile extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FA), // Light blue background
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
        ),
        backgroundColor: const Color(0xFFE8F1FA), // Light blue app bar
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User data not found', style: TextStyle(color: Color(0xFF032D64))));
          }

          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with Blue Border and Shadow
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userData['profilePicture'] ?? 'https://thumbs.dreamstime.com/b/modern-real-estate-investment-logo-design-vector-property-growing-commercial-economic-338365420.jpg'), // Default image if none exists
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 20),

                // Full Name
                Text(
                  '${userData['firstName']} ${userData['lastName'] ?? ''}',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Gender Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (userData['gender'] == 'Male')
                      Icon(Icons.male, color: Color(0xFF49AEEF), size: 24), // Male icon
                    if (userData['gender'] == 'Female')
                      Icon(Icons.female, color: Color(0xFF49AEEF), size: 24), // Female icon
                  ],
                ),
                const SizedBox(height: 10),

                // Bio Section
                Text(
                  userData['bio'] ?? 'No bio available', // Show default message if bio is empty
                  style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF49AEEF)), // Light blue text
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),

                // Join Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: Color(0xFF49AEEF), size: 18), // Light blue icon
                    const SizedBox(width: 5),
                    Text(
                      'Joined: ${_formatDate(userData['createdAt'])}',
                      style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF49AEEF)), // Light blue text
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Edit Profile Button
                ElevatedButton(
                                              onPressed: () {
                              
                            },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFF065A94),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black.withOpacity(0.2),
                    elevation: 4,
                  ),
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),

                // Log Out Button
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _auth.signOut();
                      context.go('/splash');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out successfully')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF49AEEF),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black.withOpacity(0.2),
                    elevation: 4,
                  ),
                  child: Text(
                    'Log Out',
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

  // Format date from Firestore timestamp
  String _formatDate(dynamic createdAt) {
    try {
      DateTime date = createdAt.toDate();
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A'; // Return "N/A" if formatting fails
    }
  }
}