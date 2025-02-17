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
      backgroundColor: const Color(0xFFE8F1FA), // Updated light blue background
      appBar: AppBar(
        title: Text(
          'Entrepreneur Profile',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
        ),
        backgroundColor: const Color(0xFFE8F1FA), // Light blue app bar
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(entrepreneurId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Entrepreneur not found', style: TextStyle(color: Color(0xFF032D64))));
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
                      Icon(Icons.male, color: Color(0xFF49AEEF), size: 24), // Light blue icon for Male
                    if (userData['gender'] == 'Female')
                      Icon(Icons.female, color: Color(0xFF49AEEF), size: 24), // Light blue icon for Female
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

                // Statistics Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatCard('Projects Published', '${userData['projectsPublished'] ?? 0}'),
                    const SizedBox(width: 20),
                    _buildStatCard('Success Rate', '${userData['successRate'] ?? 'N/A'}%'),
                  ],
                ),
                const SizedBox(height: 20),

                // Contact Button
                ElevatedButton(
                  onPressed: () {
                    // Add chat logic here
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message sent to entrepreneur')));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF065A94),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black.withOpacity(0.2),
                    elevation: 4,
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

  // Build a stat card
  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF1F87D2).withOpacity(0.2), // Light blue card background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF49AEEF)), // Light blue text
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // White text
          ),
        ],
      ),
    );
  }
}