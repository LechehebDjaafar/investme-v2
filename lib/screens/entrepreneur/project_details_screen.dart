import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_project_screen.dart'; // Import the edit project screen

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailsScreen({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProjectScreen(project: project),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context, project['projectId']);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Name
            Text(
              project['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Category
            Text(
              'Category: ${project['category']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            // Description
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              project['description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Target Amount
            Text(
              'Target Amount: ${project['targetAmount']} \$',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            // Completion Percentage
            Text(
              'Completion Percentage: ${project['completionPercentage']}%',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            // Current Amount
            Text(
              'Current Amount: ${project['currentAmount']} \$',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            // Status
            Chip(
              label: Text(project['status']),
              backgroundColor: getStatusColor(project['status']),
            ),
            SizedBox(height: 20),

            // Media Section
            if (project['media']['images'] != null && project['media']['images'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Images:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      project['media']['images'].length,
                      (index) => Image.network(
                        project['media']['images'][index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),

            if (project['media']['pdf'] != null && project['media']['pdf'].isNotEmpty)
              TextButton(
                onPressed: () {
                  // TODO: Open PDF in a viewer
                },
                child: Text('View PDF'),
              ),

            if (project['media']['video'] != null && project['media']['video'].isNotEmpty)
              TextButton(
                onPressed: () {
                  // TODO: Open video in a player
                },
                child: Text('Watch Video'),
              ),
          ],
        ),
      ),
    );
  }

  // Function to get status color
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

  // Confirmation dialog for deleting a project
void _showDeleteConfirmationDialog(BuildContext context, String projectId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirm Deletion'),
      content: Text('Are you sure you want to delete this project?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              // Delete the project using projectId
              await FirebaseFirestore.instance
                  .collection('projects')
                  .doc(projectId)
                  .delete();

              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to dashboard
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete project: $e')),
              );
            }
          },
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
}