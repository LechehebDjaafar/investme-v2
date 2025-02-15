import 'package:flutter/material.dart';

class ProjectsListScreen extends StatelessWidget {
  final List<Map<String, String>> projects = [
    {'name': 'Project 1', 'status': 'Accepted', 'date': '2023-10-01'},
    {'name': 'Project 2', 'status': 'Pending', 'date': '2023-10-02'},
    {'name': 'Project 3', 'status': 'Rejected', 'date': '2023-10-03'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects List'), // عنوان الشاشة
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // زر العودة
          onPressed: () {
            Navigator.pop(context); // العودة إلى الشاشة السابقة
          },
        ),
      ),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(project['name']!),
              subtitle: Text('Status: ${project['status']} - Date: ${project['date']}'),
              onTap: () {
                // الانتقال إلى شاشة تفاصيل المشروع
                Navigator.pushNamed(context, '/entrepreneur/project-details', arguments: project);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // الانتقال إلى شاشة إضافة مشروع
          Navigator.pushNamed(context, '/entrepreneur/add-project');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}