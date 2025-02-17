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
      backgroundColor: const Color(0xFFE8F1FA), // Light blue background
appBar: AppBar(
        title: Text(
          'Investor Dashboard',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
        ),
        backgroundColor: const Color(0xFFE8F1FA), // Light blue app bar
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Quick Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('User data not found', style: TextStyle(color: Color(0xFF032D64))));
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
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircularStatCard(Icons.business_center_outlined, 'Projects Invested', '$investedProjectsCount'),
                          _buildCircularStatCard(Icons.monetization_on_outlined, 'Total Investments', '\$$totalInvestments'),
                          _buildCircularStatCard(Icons.trending_up_outlined, 'Expected Returns', '\$$expectedReturns'),
                        ],
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
                    ],
                  );
                },
              ),
            ),
          ),

          // Your Invested Projects Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Your Invested Projects',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),

          // Invested Projects Grid
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('projects').where('investors', arrayContains: _auth.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('No invested projects yet', style: TextStyle(color: Color(0xFF032D64)))),
                );
              }

              List<Map<String, dynamic>> investedProjects = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Map<String, dynamic> projectData = investedProjects[index];
                    return _buildProjectCard(context, projectData);
                  },
                  childCount: investedProjects.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns in the grid
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8, // Adjust card aspect ratio
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Build a circular stat card
  Widget _buildCircularStatCard(IconData icon, String title, String value) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1F87D2), Color(0xFF065A94)], // Updated gradient colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
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
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 5),
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

  // Build a project card
  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> projectData) {
    // Check if the project has an image, otherwise use a default placeholder
    String imageUrl = (projectData['media']?['images'] as List?)?.isNotEmpty == true
        ? projectData['media']['images'][0]
        : 'https://thumbs.dreamstime.com/b/modern-real-estate-investment-logo-design-vector-property-growing-commercial-economic-338365420.jpg'; // Default image if no images exist

    return InkWell( // Make the entire card tappable
      onTap: () {
        context.go('/investor/project-details', extra: projectData['projectId']);
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        color: const Color(0xFF1F87D2).withOpacity(0.2), // Light blue card background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Project Image with Placeholder
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  'https://thumbs.dreamstime.com/b/modern-real-estate-investment-logo-design-vector-property-growing-commercial-economic-338365420.jpg', // Default placeholder image
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ), 
            ),
            const SizedBox(height: 10),

            // Project Name (Flexible to handle long titles)
            Flexible(
              child: Text(
                projectData['name'] ?? 'Unnamed Project',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),

            // Project Category
            Text(
              'Category: ${projectData['category'] ?? 'N/A'}',
              style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF49AEEF)), // Light blue text
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),

            // Funding Details
            Text(
              'Funded: ${_calculateFundingPercentage(projectData['currentAmount'], projectData['targetAmount'])}%',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.green), // Green text for funding percentage
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Calculate funding percentage
  String _calculateFundingPercentage(dynamic currentAmount, dynamic targetAmount) {
    try {
      int current = currentAmount is int ? currentAmount : int.parse(currentAmount.toString());
      int target = targetAmount is int ? targetAmount : int.parse(targetAmount.toString());
      if (target == 0) return 'N/A'; // Avoid division by zero
      double percentage = (current / target * 100).clamp(0, 100);
      return percentage.toStringAsFixed(0);
    } catch (e) {
      return 'N/A';
    }
  }
}