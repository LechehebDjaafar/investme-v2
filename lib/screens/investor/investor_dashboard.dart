import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvestorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // Dark blue background
      appBar: AppBar(
        title: Text(
          'Investor Dashboard',
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
            // Section 1: Quick Stats
            Text(
              'Quick Stats',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Projects Invested', '5'),
                _buildStatCard('Total Investments', '\$10,000'),
                _buildStatCard('Expected Returns', '\$2,000'),
              ],
            ),
            const SizedBox(height: 20),

            // Section 2: Browse Projects Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/browse_projects');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFFF4B400), // White text
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Browse Projects',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),

            // Section 3: Invested Projects List
            Text(
              'Your Invested Projects',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Example project count
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

  // Build a stat card for quick stats
  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), // Semi-transparent white
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white30, width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white70, // Light gray text
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text
            ),
          ),
        ],
      ),
    );
  }

  // Build a project card for invested projects
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
          'Invested \$2,000 | Expected Return \$500',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white70, // Light gray text
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70), // Arrow icon
        onTap: () {
          Navigator.pushNamed(context, '/project_details');
        },
      ),
    );
  }
}