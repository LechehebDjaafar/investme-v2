import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetails extends StatelessWidget {
  final String projectId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProjectDetails({required this.projectId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FA), // Light blue background
      appBar: AppBar(
        title: Text(
          'Project Details',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF032D64), // Dark blue for app bar
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('projects').doc(projectId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Project not found', style: TextStyle(color: const Color(0xFF032D64))));
          }

          Map<String, dynamic> projectData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Image with Gradient Overlay
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(projectData['media']['images'][0] ?? 'default_image_url'),
                      fit: BoxFit.cover,
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        projectData['name'],
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Project Description
                Text(
                  projectData['description'],
                  style: GoogleFonts.poppins(fontSize: 16, color: const Color(0xFF49AEEF)),
                ),
                const SizedBox(height: 20),

                // Funding Details
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      'Current Amount: ${projectData['currentAmount']}', // إصلاح هنا
      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
    ),
    Text(
      'Target Amount: ${projectData['targetAmount']}', // إصلاح هنا
      style: GoogleFonts.poppins(fontSize: 16, color: Colors.green),
    ),
  ],
),
                const SizedBox(height: 10),

                // Progress Bar
                LinearProgressIndicator(
                  value: _calculateFundingPercentage(projectData['currentAmount'], projectData['targetAmount']),
                  backgroundColor: const Color(0xFF1F87D2).withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF065A94)),
                ),
                const SizedBox(height: 20),

                // Invest Now Button
                ElevatedButton(
                  onPressed: () async {
                    await _firestore.collection('projects').doc(projectId).update({
                      'currentAmount': FieldValue.increment(100),
                      'investors': FieldValue.arrayUnion([_auth.currentUser!.uid]),
                    });
                    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
                      'investedProjects': FieldValue.arrayUnion([projectId]),
                      'totalInvestments': FieldValue.increment(100),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Investment successful')));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFF065A94),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.2),
                  ),
                  child: Text(
                    'Invest Now',
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

  double _calculateFundingPercentage(dynamic currentAmount, dynamic targetAmount) {
    try {
      int current = currentAmount is int ? currentAmount : int.parse(currentAmount.toString());
      int target = targetAmount is int ? targetAmount : int.parse(targetAmount.toString());
      return (current / target).clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }
}