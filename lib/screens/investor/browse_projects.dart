import 'package:flutter/material.dart';

class BrowseProjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Projects'),
        backgroundColor: Color(0xFF1E2A47),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Filter Options
            Text(
              'Filters',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 5),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Technology'),
                _buildFilterChip('Healthcare'),
                _buildFilterChip('Education'),
                _buildFilterChip('Real Estate'),
              ],
            ),
            SizedBox(height: 20),

            // Project List
            Text(
              'Available Projects',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 10),
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

  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: Colors.black),
    );
  }

  Widget _buildProjectCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('Project Name'),
        subtitle: Text('Description of the project...'),
        trailing: Text('\$10,000 Needed'),
        onTap: () {
          Navigator.pushNamed(context, '/project_details');
        },
      ),
    );
  }
}