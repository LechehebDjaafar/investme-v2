import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvestorDashboard extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47),
      appBar: AppBar(
        title: Text(
          'Investor Dashboard',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E2A47),
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
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('User data not found', style: TextStyle(color: Colors.white));
                }

                Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
                int investedProjectsCount = userData['investedProjects']?.length ?? 0;
                double totalInvestments = userData['totalInvestments'] ?? 0;
                double expectedReturns = userData['expectedReturns'] ?? 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Stats',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard('Projects Invested', '$investedProjectsCount'),
                        _buildStatCard('Total Investments', '\$$totalInvestments'),
                        _buildStatCard('Expected Returns', '\$$expectedReturns'),
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
                foregroundColor: Colors.white, backgroundColor: const Color(0xFFF4B400),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Browse Projects',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),

            // Invested Projects List
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('projects')
                  .where('investors', arrayContains: _auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No invested projects yet', style: TextStyle(color: Colors.white));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Invested Projects',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> projectData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                       return _buildProjectCard(
                        context,
  projectData['name'], 
  '${projectData['currentAmount']}', 
  '${projectData['targetAmount']}'
);
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
  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white30, width: 1),
      ),
      child: Column(
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

  Widget _buildProjectCard(BuildContext context,String projectName, String currentAmount, String targetAmount) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white.withOpacity(0.1),
      child: ListTile(
        title: Text(
          projectName,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        ),
        subtitle: Text(
          'Invested $currentAmount | Target $targetAmount',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: () => Navigator.pushNamed(context, '/project_details'),
      ),
    );
  }
}