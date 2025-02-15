import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProjectScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const EditProjectScreen({required this.project});

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetAmountController;
  late TextEditingController _expectedCompletionDateController;

  double _completionPercentage = 0;
  double _currentAmount = 0;
  int _investorCount = 0;
  List<String> _images = [];
  String _pdf = '';
  String _video = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project['name']);
    _categoryController = TextEditingController(text: widget.project['category']);
    _descriptionController = TextEditingController(text: widget.project['description']);
    _targetAmountController = TextEditingController(text: widget.project['targetAmount'].toString());
    _expectedCompletionDateController = TextEditingController(
        text: widget.project['expectedCompletionDate'].toDate().toIso8601String().split('T')[0]);
    _completionPercentage = widget.project['completionPercentage'].toDouble();
    _currentAmount = widget.project['currentAmount'].toDouble();
    _investorCount = widget.project['investorCount'];
    _images = List.from(widget.project['media']['images']);
    _pdf = widget.project['media']['pdf'];
    _video = widget.project['media']['video'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Same fields as AddProjectScreen but pre-filled with current data
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Project Name'),
            ),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _targetAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Target Amount'),
            ),
            TextFormField(
              controller: _expectedCompletionDateController,
              decoration: InputDecoration(labelText: 'Expected Completion Date'),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _expectedCompletionDateController.text =
                        picked.toIso8601String().split('T')[0];
                  });
                }
              },
            ),
            Slider(
              value: _completionPercentage,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_completionPercentage.round()}%',
              onChanged: (double value) {
                setState(() {
                  _completionPercentage = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateProject();
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

Future<void> _updateProject() async {
  try {
    final updatedData = {
      'name': _nameController.text,
      'category': _categoryController.text,
      'description': _descriptionController.text,
      'targetAmount': double.tryParse(_targetAmountController.text) ?? 0,
      'expectedCompletionDate': Timestamp.fromDate(
          DateTime.parse(_expectedCompletionDateController.text)),
      'completionPercentage': _completionPercentage,
      'currentAmount': _currentAmount,
      'investorCount': _investorCount,
      'media': {
        'images': _images,
        'pdf': _pdf,
        'video': _video,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Update the project using projectId
    await _db.collection('projects').doc(widget.project['projectId']).update(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Project updated successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update project: $e')),
    );
  }
}
}