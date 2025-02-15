import 'package:flutter/material.dart';

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

  Color getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Under Review':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text(description),
        trailing: Chip(
          label: Text(status),
          backgroundColor: getStatusColor(status),
        ),
        onTap: onTap,
      ),
    );
  }
}