import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_project_screen.dart';
import 'project_card.dart';
import 'project_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InvestMe'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddProjectScreen()));
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
                        StatCard(title: 'Total Projects', count: totalProjects),
                        StatCard(title: 'Accepted', count: acceptedProjects, color: Colors.green),
                        StatCard(title: 'Rejected', count: rejectedProjects, color: Colors.red),
                        StatCard(title: 'Under Review', count: underReviewProjects, color: Colors.yellow),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),

            // Projects List
            Text(
              'Your Projects:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getProjectsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
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
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: project)));
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
              child: Text('View All'),
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
        color: color ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}