import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrowseProjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // Dark blue background
      appBar: AppBar(
        title: Text(
          'Browse Projects',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text
          ),
        ),
        backgroundColor: const Color(0xFF1E2A47), // Dark blue background
        elevation: 0, // Remove shadow
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
                fillColor: Colors.white.withOpacity(0.1), // Semi-transparent white
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
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
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
            Text(
              'Available Projects',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Example project count
                itemBuilder: (context, index) {
                  return _buildProjectCard(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a filter chip
  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(
        label,
        style: GoogleFonts.poppins(color: Colors.white70),
      ),
      backgroundColor: Colors.white.withOpacity(0.1), // Semi-transparent white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // Build a project card
  Widget _buildProjectCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white.withOpacity(0.1), // Semi-transparent white
      child: ListTile(
        leading: Icon(Icons.business, color: Colors.white70), // Project icon
        title: Text(
          'Project Name',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white, // White text
          ),
        ),
        subtitle: Text(
          'Description of the project...',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white70, // Light gray text
          ),
        ),
        trailing: Text(
          '\$5,000 Needed',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white, // White text
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/project_details');
        },
      ),
    );
  }
}