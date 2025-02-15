import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, String> project;

  const ProjectDetailsScreen({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'), // عنوان الشاشة
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // زر العودة
          onPressed: () {
            Navigator.pop(context); // العودة إلى الشاشة السابقة
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${project['name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Status: ${project['status']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Date: ${project['date']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // الانتقال إلى شاشة تعديل المشروع
                    Navigator.pushNamed(context, '/entrepreneur/edit-project', arguments: project);
                  },
                  child: Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // عرض تأكيد الحذف
                    _showDeleteConfirmationDialog(context);
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Project'),
          content: Text('Are you sure you want to delete this project?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق النافذة
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // حذف المشروع
                Navigator.pop(context); // إغلاق النافذة
                Navigator.pop(context); // العودة إلى قائمة المشاريع
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}