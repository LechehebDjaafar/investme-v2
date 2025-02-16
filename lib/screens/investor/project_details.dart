import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetails extends StatelessWidget {
  final String projectId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProjectDetails({required this.projectId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47),
      appBar: AppBar(
        title: Text(
          'Project Details',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E2A47),
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('projects').doc(projectId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Project not found', style: TextStyle(color: Colors.white)));
          }

          Map<String, dynamic> projectData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectData['name'],
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  projectData['description'],
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _firestore.collection('projects').doc(projectId).update({
                      'currentAmount': FieldValue.increment(100), // Example investment amount
                      'investors': FieldValue.arrayUnion([_auth.currentUser!.uid]),
                    });

                    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
                      'investedProjects': FieldValue.arrayUnion([projectId]),
                      'totalInvestments': FieldValue.increment(100),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Investment successful')));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFFF4B400),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
}