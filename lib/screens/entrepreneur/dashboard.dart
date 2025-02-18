import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_project_screen.dart';
import 'project_card.dart';
import 'project_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE), // خلفية أزرق فاتح جدًا
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3), // أزرق مشرق
        title: Text(
          'InvestMe',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProjectScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Section
            StreamBuilder<QuerySnapshot>(
              stream: _getProjectsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final projects = snapshot.data!.docs;
                int totalProjects = projects.length;
                int acceptedProjects = projects.where((p) => p['status'] == 'Accepted').length;
                int rejectedProjects = projects.where((p) => p['status'] == 'Rejected').length;
                int underReviewProjects = projects.where((p) => p['status'] == 'Under Review').length;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatCard(
                          title: 'Total Projects',
                          count: totalProjects,
                          color: const Color(0xFF42A5F5), // أزرق متوسط فاتح
                        ),
                        StatCard(
                          title: 'Accepted',
                          count: acceptedProjects,
                          color: const Color(0xFF00C853), // أخضر فاتح
                        ),
                        StatCard(
                          title: 'Rejected',
                          count: rejectedProjects,
                          color: const Color(0xFFBBDEFB), // أزرق فاتح جدًا
                        ),
                        StatCard(
                          title: 'Under Review',
                          count: underReviewProjects,
                          color: const Color(0xFFFFA000), // برتقالي مشرق
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
            // Projects List
            Text(
              'Your Projects:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A237E), // أزرق داكن غني
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getProjectsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final projects = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index].data() as Map<String, dynamic>;
                      project['projectId'] = projects[index].id; // Add projectId to the project data
                      return ProjectCard(
                        name: project['name'],
                        description: project['description'],
                        status: project['status'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetailsScreen(project: project),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            // View All Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/projects_list');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3), // أزرق مشرق
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "View All",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get projects for the current user
  Stream<QuerySnapshot> _getProjectsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.empty();
    }
    return _db
        .collection('projects')
        .where('entrepreneurId', isEqualTo: user.uid)
        .snapshots();
  }
}

// Component for Statistics Card
class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color? color;

  const StatCard({required this.title, required this.count, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFBBDEFB), // أزرق فاتح جدًا
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A237E), // أزرق داكن غني
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color.fromARGB(255, 244, 247, 249), // أزرق متوسط فاتح
            ),
          ),
        ],
      ),
    );
  }
}