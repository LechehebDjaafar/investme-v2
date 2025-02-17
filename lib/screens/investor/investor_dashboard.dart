import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class InvestorDashboard extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FA), // Light blue background with gradient
      appBar: AppBar(
        title: Text(
          'Investor Dashboard',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF032D64), // Dark blue for app bar
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Section
            FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('User data not found', style: TextStyle(color: const Color(0xFF032D64))));
                }

                Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
                int investedProjectsCount = userData['investedProjects']?.length ?? 0;
                double totalInvestments = (userData['totalInvestments'] ?? 0).toDouble();
                double expectedReturns = (userData['expectedReturns'] ?? 0).toDouble();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Stats',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF032D64)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard('Projects Invested', '$investedProjectsCount', const Color(0xFF1F87D2)),
                        _buildStatCard('Total Investments', '\$$totalInvestments', const Color(0xFF065A94)),
                        _buildStatCard('Expected Returns', '\$$expectedReturns', const Color(0xFF49AEEF)),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Browse Projects Button
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/browse_projects'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFF065A94),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.2),
              ),
              child: Text(
                'Browse Projects',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),

            // Invested Projects Grid
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('projects').where('investors', arrayContains: _auth.currentUser!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No invested projects yet', style: TextStyle(color: const Color(0xFF032D64))));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Invested Projects',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF032D64)),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> projectData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return _buildProjectCard(projectData['name'], '${projectData['currentAmount']}', '${projectData['targetAmount']}', projectData['projectId']);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build a stat card with glassmorphism effect
  Widget _buildStatCard(String title, String value, Color cardColor) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.8), // Glassmorphism effect
        borderRadius: BorderRadius.circular(15),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Build a project card with glassmorphism effect
  Widget _buildProjectCard(String projectName, String currentAmount, String targetAmount, String projectId) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.white.withOpacity(0.8), // Glassmorphism effect
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/project_image.jpg', width: 100, height: 100, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(
            projectName,
            style: GoogleFonts.poppins(fontSize: 16, color: const Color(0xFF032D64)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'Invested $currentAmount | Target $targetAmount',
            style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF49AEEF)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}