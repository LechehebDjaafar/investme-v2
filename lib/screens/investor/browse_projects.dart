import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class BrowseProjects extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FA), // Light blue background
      appBar: AppBar(
        title: Text(
          'Browse Projects',
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
            // Search Bar
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1F87D2).withOpacity(0.1),
                prefixIcon: Icon(Icons.search, color: const Color(0xFF49AEEF)),
                hintText: 'Search projects...',
                hintStyle: GoogleFonts.poppins(color: const Color(0xFF49AEEF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Filters
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Technology', Icons.computer),
                _buildFilterChip('Healthcare', Icons.local_hospital),
                _buildFilterChip('Education', Icons.school),
                _buildFilterChip('Real Estate', Icons.home),
              ],
            ),
            const SizedBox(height: 20),

            // Projects Grid
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('projects').where('status', isEqualTo: 'Accepted').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No projects available', style: TextStyle(color: const Color(0xFF032D64))));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Projects',
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

  Widget _buildFilterChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18, color: const Color(0xFF49AEEF)),
      label: Text(label, style: GoogleFonts.poppins(color: const Color(0xFF49AEEF))),
      backgroundColor: const Color(0xFFE8F1FA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

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
            'Funded: ${_calculateFundingPercentage(currentAmount, targetAmount)}%',
            style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF49AEEF)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _calculateFundingPercentage(String currentAmount, String targetAmount) {
    try {
      int current = int.parse(currentAmount);
      int target = int.parse(targetAmount);
      return (current / target * 100).clamp(0.0, 100.0);
    } catch (e) {
      return 0.0;
    }
  }
}