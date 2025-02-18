import 'dart:math';

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
          onPressed: () => context.go('/investor/main'), // Navigate back to main screen
        ),
        title: Text(
          'Project Details',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF032D64)),
        ),
        backgroundColor: const Color(0xFFE8F1FA), // Dark blue app bar
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

                  // Funding Progress Circle
                  Text(
                    'Funding Progress',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF032D64)),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: _calculateFundingPercentage(projectData['currentAmount'], projectData['targetAmount'])),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer Circle
                            Container(
                              width: 100,
                              height: 100,
                              child: CustomPaint(
                                painter: CircularPainter(value, Colors.green.withOpacity(value > 0.5 ? 1.0 : 0.5), Colors.blue.withOpacity(value <= 0.5 ? 1.0 : 0.5)),
                              ),
                            ),
                            // Percentage Text
                            Text(
                              '${(value * 100).toStringAsFixed(value.toInt())}%',
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Current Amount: \$${projectData['currentAmount']} | Target Amount: \$${projectData['targetAmount']}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF49AEEF)),
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
                      projectData['media']?['images']?.isNotEmpty == true
                          ? projectData['media']['images'][0]
                          : 'https://thumbs.dreamstime.com/b/modern-real-estate-investment-logo-design-vector-property-growing-commercial-economic-338365420.jpg',
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
                            backgroundImage: NetworkImage(entrepreneurData['profilePicture'] ?? 'https://via.placeholder.com/150'),
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
                  onPressed: () {
                    _showInvestmentDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF065A94),
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


  void _showInvestmentDialog(BuildContext context) {
  final TextEditingController _amountController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          'Enter Investment Amount',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF032D64)),
        ),
        content: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount (\$)',
            labelStyle: TextStyle(color: Color(0xFF49AEEF)), // Light blue text
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.red), // Red text for cancel
            ),
          ),
          TextButton(
            onPressed: () {
              final String amount = _amountController.text.trim();
              if (amount.isNotEmpty && double.tryParse(amount) != null) {
                // Process the investment amount
                _processInvestment(double.parse(amount),context);
                Navigator.of(dialogContext).pop(); // Close the dialog
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a valid amount', style: GoogleFonts.poppins(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              'Confirm',
              style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF00C853)), // Green text for confirm
            ),
          ),
        ],
      );
    },
  );
} 

  void _processInvestment(double amount,BuildContext context) async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not authenticated', style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String projectId = ModalRoute.of(context)?.settings.arguments as String;

    // Fetch project details
    final projectSnapshot = await _firestore.collection('projects').doc(projectId).get();
    if (!projectSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project not found', style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final Map<String, dynamic> projectData = projectSnapshot.data()!;
    final double currentAmount = (projectData['currentAmount'] ?? 0).toDouble();
    final double targetAmount = (projectData['targetAmount'] ?? 0).toDouble();

    // Update project's current amount
    final newCurrentAmount = currentAmount + amount;
    if (newCurrentAmount > targetAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Investment exceeds the target amount', style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update project in Firestore
    await _firestore.collection('projects').doc(projectId).update({
      'currentAmount': newCurrentAmount,
    });

    // Add project to user's invested projects
    final userSnapshot = await _firestore.collection('users').doc(user.uid).get();
    if (userSnapshot.exists) {
      final List<dynamic> investedProjects = List.from(userSnapshot.data()?['investedProjects'] ?? []);
      if (!investedProjects.contains(projectId)) {
        investedProjects.add(projectId);
        await _firestore.collection('users').doc(user.uid).update({
          'investedProjects': investedProjects,
          'totalInvestments': FieldValue.increment(amount),
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Investment successful!', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error processing investment: $e', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }
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

// Custom Painter for Circular Progress
class CircularPainter extends CustomPainter {
  final double progress;
  final Color completedColor;
  final Color backgroundColor;

  CircularPainter(this.progress, this.completedColor, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint completedPaint = Paint()
      ..color = completedColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - backgroundPaint.strokeWidth / 2;

    // Draw Background Circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw Completed Arc
    double arcAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, completedPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}