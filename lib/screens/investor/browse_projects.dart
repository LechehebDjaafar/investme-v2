import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BrowseProjects extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47),
      appBar: AppBar(
        title: Text(
          'Browse Projects',
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
            // Search Bar
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                hintText: 'Search projects...',
                hintStyle: GoogleFonts.poppins(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Filters
            Text(
              'Filters',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Technology'),
                _buildFilterChip('Healthcare'),
                _buildFilterChip('Education'),
                _buildFilterChip('Real Estate'),
              ],
            ),
            const SizedBox(height: 20),

            // Projects List
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('projects').where('status', isEqualTo: 'Accepted').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No projects available', style: TextStyle(color: Colors.white));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Projects',
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
                       '${projectData['targetAmount']}', 
                        projectData['projectId']
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

  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(label, style: GoogleFonts.poppins(color: Colors.white70)),
      backgroundColor: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildProjectCard( BuildContext context,String projectName, String currentAmount, String targetAmount, String projectId) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white.withOpacity(0.1),
      child: ListTile(
        title: Text(
          projectName,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        ),
        subtitle: Text(
          'Current Amount: $currentAmount | Target: $targetAmount',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: () {
          context.go('/investor/project-details', extra: projectId);
        },
      ),
    );
  }
}