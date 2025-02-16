import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // Dark blue background
      appBar: AppBar(
        title: Text(
          'Project Details',
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
            // Project Title
            Text(
              'Project Title',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 10),
            // Project Description
            Text(
              'This is a detailed description of the project...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70, // Light gray text
              ),
            ),
            const SizedBox(height: 20),
            // Project Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount Needed: \$10,000',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70, // Light gray text
                  ),
                ),
                Text(
                  'Expected Return: 20%',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.green, // Green text
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Invest Now Button
            ElevatedButton(
              onPressed: () {
                // Add investment logic here
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFFF4B400), // White text
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Invest Now',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}