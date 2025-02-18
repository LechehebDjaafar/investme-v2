import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // Function to get status color based on status
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4, // Add shadow for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16), // Add padding for better spacing
        title: Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A237E), // Dark Blue
          ),
        ),
        subtitle: Text(
          description,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF42A5F5), // Light Blue
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: getStatusColor(status),
            borderRadius: BorderRadius.circular(8), // Rounded corners for the status chip
          ),
          child: Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white, // White text for contrast
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}