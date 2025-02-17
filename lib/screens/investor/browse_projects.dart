import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BrowseProjects extends StatefulWidget {
  @override
  _BrowseProjectsState createState() => _BrowseProjectsState();
}

class _BrowseProjectsState extends State<BrowseProjects> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedFilter; // Variable to track the selected filter
  String searchQuery = ''; // Search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FA), // Light blue background
      appBar: AppBar(
        title: Text(
          'Browse Projects',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
        ),
        backgroundColor: const Color(0xFFE8F1FA), // Light blue app bar
        elevation: 0,
      ),
      body: CustomScrollView( // Use CustomScrollView for smooth scrolling
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value; // Update search query
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF49AEEF)), // Light blue icon
                      hintText: 'Search projects...',
                      hintStyle: GoogleFonts.poppins(color: Color(0xFF49AEEF)), // Light blue hint
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xFF065A94), width: 1), // Medium blue border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xFF065A94), width: 2), // Medium blue border when focused
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Filters
                  Text(
                    'Filters',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip('Technology', Icons.computer, Color(0xFF49AEEF), 'Technology'),
                      _buildFilterChip('Healthcare', Icons.local_hospital, Color(0xFF49AEEF), 'Healthcare'),
                      _buildFilterChip('Education', Icons.school, Color(0xFF49AEEF), 'Education'),
                      _buildFilterChip('Real Estate', Icons.home, Color(0xFF49AEEF), 'Real Estate'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Available Projects Title
                  Text(
                    'Available Projects',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF032D64)), // Dark blue text
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // Projects Grid
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('projects')
                .where('status', isEqualTo: 'Accepted')
                .where('category', isEqualTo: selectedFilter)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('No projects available', style: TextStyle(color: Color(0xFF032D64)))),
                );
              }

              List<Map<String, dynamic>> filteredProjects = snapshot.data!.docs
                  .where((project) =>
                      project['name']
                          ?.toString()
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ??
                      false)
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Map<String, dynamic> projectData = filteredProjects[index];
                    return _buildProjectCard(context, projectData);
                  },
                  childCount: filteredProjects.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns in the grid
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8, // Adjust card aspect ratio
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Build a filter chip
  Widget _buildFilterChip(String label, IconData icon, Color textColor, String category) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: selectedFilter == category ? Colors.white : textColor),
      label: Text(label, style: GoogleFonts.poppins(color: selectedFilter == category ? Colors.white : textColor)),
      backgroundColor: selectedFilter == category
          ? Color(0xFF065A94).withOpacity(0.8) // Medium blue when active
          : Colors.white.withOpacity(0.2), // Light blue when inactive
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onPressed: () {
        setState(() {
          selectedFilter = selectedFilter == category ? null : category; // Toggle filter
        });
      },
    );
  }

  // Build a project card
  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> projectData) {
    // Check if the project has an image, otherwise use a default placeholder
    String imageUrl = (projectData['media']?['images'] as List?)?.isNotEmpty == true
        ? projectData['media']['images'][0]
        : 'https://thumbs.dreamstime.com/b/modern-real-estate-investment-logo-design-vector-property-growing-commercial-economic-338365420.jpg'; // Default image if no images exist

    return InkWell( // Make the entire card tappable
      onTap: () {
        context.go('/investor/project-details', extra: projectData['projectId']);
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        color: const Color(0xFF1F87D2).withOpacity(0.2), // Light blue card background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Make the column flexible and minimal
          children: [
            // Project Image with Placeholder
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  'https://thumbs.dreamstime.com/b/modern-real-estate-investment-logo-design-vector-property-growing-commercial-economic-338365420.jpg', // Default placeholder image
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Project Name (Flexible to handle long titles)
            Flexible(
              child: Text(
                projectData['name'] ?? 'Unnamed Project',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),

            // Project Category
            Text(
              'Category: ${projectData['category'] ?? 'N/A'}',
              style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF49AEEF)), // Light blue text
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),

            // Funding Details
            Text(
              'Funded: ${_calculateFundingPercentage(projectData['currentAmount'], projectData['targetAmount'])}%',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.green), // Green text for funding percentage
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Calculate funding percentage
  String _calculateFundingPercentage(dynamic currentAmount, dynamic targetAmount) {
    try {
      int current = currentAmount is int ? currentAmount : int.parse(currentAmount.toString());
      int target = targetAmount is int ? targetAmount : int.parse(targetAmount.toString());
      if (target == 0) return 'N/A'; // Avoid division by zero
      double percentage = (current / target * 100).clamp(0, 100);
      return percentage.toStringAsFixed(0);
    } catch (e) {
      return 'N/A';
    }
  }
}