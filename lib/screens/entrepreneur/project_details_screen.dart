import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_project_screen.dart'; // Import the edit project screen

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailsScreen({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE), // Light Blue Background
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3), // Bright Blue
        title: Text(
          'Project Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
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
            icon: Icon(Icons.delete, color: Colors.red),
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
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A237E), // Dark Blue
              ),
            ),
            const SizedBox(height: 10),
            // Category
            Text(
              'Category: ${project['category']}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF42A5F5), // Light Blue
              ),
            ),
            const SizedBox(height: 10),
            // Description
            Text(
              'Description:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A237E), // Dark Blue
              ),
            ),
            Text(
              project['description'],
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF42A5F5), // Light Blue
              ),
            ),
            const SizedBox(height: 20),
            // Target Amount
            Text(
              'Target Amount: ${project['targetAmount']} \$',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF1A237E), // Dark Blue
              ),
            ),
            const SizedBox(height: 10),
            // Completion Percentage
            Text(
              'Completion Percentage: ${project['completionPercentage']}%',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF42A5F5), // Light Blue
              ),
            ),
            const SizedBox(height: 10),
            // Current Amount
            Text(
              'Current Amount: ${project['currentAmount']} \$',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF1A237E), // Dark Blue
              ),
            ),
            const SizedBox(height: 10),
            // Status
            Chip(
              label: Text(
                project['status'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              backgroundColor: getStatusColor(project['status']),
            ),
            const SizedBox(height: 20),
            // Media Section
            if (project['media']['images'] != null && project['media']['images'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Images:',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A237E), // Dark Blue
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      project['media']['images'].length,
                      (index) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          project['media']['images'][index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            if (project['media']['pdf'] != null && project['media']['pdf'].isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  // TODO: Open PDF in a viewer
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3), // Bright Blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'View PDF',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            if (project['media']['video'] != null && project['media']['video'].isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  // TODO: Open video in a player
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3), // Bright Blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Watch Video',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                ),
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
        return const Color(0xFF00C853); // Green
      case 'Rejected':
        return const Color(0xFFBBDEFB); // Light Blue
      case 'Under Review':
        return const Color(0xFFFFA000); // Orange
      default:
        return const Color(0xFF42A5F5); // Light Blue
    }
  }

  // Confirmation dialog for deleting a project
  void _showDeleteConfirmationDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Deletion',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1A237E)),
        ),
        content: Text(
          'Are you sure you want to delete this project?',
          style: GoogleFonts.poppins(color: const Color(0xFF42A5F5)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: const Color(0xFF2196F3)),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Delete the project using projectId
                await FirebaseFirestore.instance.collection('projects').doc(projectId).delete();
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to dashboard
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete project: $e')),
                );
              }
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}