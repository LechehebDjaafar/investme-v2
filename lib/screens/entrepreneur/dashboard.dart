import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_project_screen.dart'; // استيراد صفحة إضافة المشروع

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatCard(title: 'Total Projects', count: 0),
                StatCard(title: 'Accepted', count: 0, color: Colors.green),
                StatCard(title: 'Rejected', count: 0, color: Colors.red),
                StatCard(title: 'Under Review', count: 0, color: Colors.yellow),
              ],
            ),
            SizedBox(height: 20),

            // Projects List
            Text(
              'Your Projects:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db.collection('projects').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final projects = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index].data() as Map<String, dynamic>;
                      return ProjectCard(
                        name: project['name'],
                        description: project['description'],
                        status: project['status'],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/project_details',
                            arguments: project,
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
              child: Text('View All'),
            ),
          ],
        ),
      ),
    );
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

// Component for Project Card
class ProjectCard extends StatelessWidget {
  final String name;
  final String description;
  final String status;
  final VoidCallback onTap;

  const ProjectCard({
    required this.name,
    required this.description,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text(description),
        trailing: Chip(
          label: Text(status),
          backgroundColor: getStatusColor(status),
        ),
        onTap: onTap,
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Under Review':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}