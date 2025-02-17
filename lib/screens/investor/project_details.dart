import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetails extends StatelessWidget {
  final String projectId;

  const ProjectDetails({required this.projectId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FA), // Light blue background
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF032D64)), // Dark blue back arrow
          onPressed: () => Navigator.pop(context), // Back button to browse projects
        ),
        title: Text(
          'Project Details',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF032D64), // Dark blue app bar
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('projects').doc(projectId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Project not found', style: TextStyle(color: Color(0xFF032D64))));
          }

          Map<String, dynamic>? projectData = snapshot.data?.data() as Map<String, dynamic>?;

          // Check if projectData is null or missing required fields
          if (projectData == null ||
              projectData['name'] == null ||
              projectData['category'] == null ||
              projectData['currentAmount'] == null ||
              projectData['targetAmount'] == null) {
            return Center(child: Text('Invalid project data', style: TextStyle(color: Color(0xFF032D64))));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Title
                  Text(
                    projectData['name'] ?? 'Unnamed Project',
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF032D64)),
                  ),
                  const SizedBox(height: 10),

                  // Project Category
                  Row(
                    children: [
                      Icon(Icons.category, color: Color(0xFF49AEEF), size: 18),
                      const SizedBox(width: 5),
                      Text(
                        'Category: ${projectData['category'] ?? 'N/A'}',
                        style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF49AEEF)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Funding Progress
                  Text(
                    'Funding Progress',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF032D64)),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: _calculateFundingPercentage(projectData['currentAmount'], projectData['targetAmount']),
                    backgroundColor: Color(0xFF1F87D2).withOpacity(0.5),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF065A94)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_calculateFundingPercentage(projectData['currentAmount'], projectData['targetAmount']) * 100}% Funded',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.green),
                  ),
                  const SizedBox(height: 10),

                  // Current and Target Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Amount: \$${projectData['currentAmount'] ?? 'N/A'}',
                        style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF49AEEF)),
                      ),
                      Text(
                        'Target Amount: \$${projectData['targetAmount'] ?? 'N/A'}',
                        style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF49AEEF)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Project Description
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF032D64)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    projectData['description'] ?? 'No description available',
                    style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF49AEEF)),
                  ),
                  const SizedBox(height: 20),

                  // Project Image with Placeholder
                  Text(
                    'Project Image',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF032D64)),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      projectData['media']['images'][0] ??
                          'https://thumbs.dreamstime.com/b/modern-real-estate-investment-logo-design-vector-property-growing-commercial-economic-338365420.jpg',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.network(
                        'https://thumbs.dreamstime.com/b/modern-real-estate-investment-logo-design-vector-property-growing-commercial-economic-338365420.jpg',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Entrepreneur Details
                  Text(
                    'Entrepreneur Details',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF032D64)),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(projectData['entrepreneurId']).get(),
                    builder: (context, entrepreneurSnapshot) {
                      if (entrepreneurSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!entrepreneurSnapshot.hasData || !entrepreneurSnapshot.data!.exists) {
                        return Text('Entrepreneur data not found', style: TextStyle(color: Color(0xFF032D64)));
                      }

                      Map<String, dynamic> entrepreneurData =
                          entrepreneurSnapshot.data!.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: Color(0xFF1F87D2).withOpacity(0.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                entrepreneurData['profilePicture'] ?? 'https://via.placeholder.com/150'),
                          ),
                          title: Text(
                            '${entrepreneurData['firstName']} ${entrepreneurData['lastName'] ?? ''}',
                            style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF032D64)),
                          ),
                          subtitle: Text(
                            entrepreneurData['bio'] ?? 'No bio available',
                            style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF49AEEF)),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              context.go('/investor/profile-entrepreneur', extra: projectData['projectId']);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF065A94),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              'Contact',
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Invest Now Button
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Increment investor count by 1
                        await FirebaseFirestore.instance.collection('projects').doc(projectId).update({
                          'investorCount': FieldValue.increment(1),
                          'currentAmount': FieldValue.increment(100),
                        });

                        // Update user's invested projects
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'investedProjects': FieldValue.arrayUnion([projectId]),
                          'totalInvestments': FieldValue.increment(100),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Investment successful')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error investing: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF065A94),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.2),
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
        },
      ),
    );
  }

  // Calculate funding percentage
  double _calculateFundingPercentage(dynamic currentAmount, dynamic targetAmount) {
    try {
      int current = currentAmount is int ? currentAmount : int.parse(currentAmount.toString());
      int target = targetAmount is int ? targetAmount : int.parse(targetAmount.toString());
      if (target == 0) return 0; // Avoid division by zero
      return (current / target).clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }
}