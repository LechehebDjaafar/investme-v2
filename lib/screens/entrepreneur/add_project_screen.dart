import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Keys for Form Validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _expectedCompletionDateController = TextEditingController();

  double _completionPercentage = 0; // Default completion percentage
  double _currentAmount = 0; // Default current amount
  int _investorCount = 0; // Default investor count
  List<String> _images = []; // List of image URLs
  String _pdf = ''; // PDF URL
  String _video = ''; // Video URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Project Name (Required)
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Project Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project name';
                  }
                  return null;
                },
              ),

              // Category (Required)
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),

              // Description (Required)
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),

              // Target Amount (Required)
              TextFormField(
                controller: _targetAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Target Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid target amount';
                  }
                  return null;
                },
              ),

              // Expected Completion Date (Required)
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an expected completion date';
                  }
                  return null;
                },
              ),

              // Completion Percentage (Optional)
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
              Text('Completion Percentage: ${_completionPercentage.round()}%'),

              // Current Amount (Optional)
              Slider(
                value: _currentAmount,
                min: 0,
                max: double.tryParse(_targetAmountController.text.isNotEmpty
                    ? _targetAmountController.text
                    : '0') ?? 0,
                divisions: 100,
                label: '$_currentAmount',
                onChanged: (double value) {
                  setState(() {
                    _currentAmount = value;
                  });
                },
              ),
              Text('Current Amount: $_currentAmount'),

              // Investor Count (Optional)
              TextFormField(
                initialValue: '0',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Investor Count'),
                onChanged: (value) {
                  setState(() {
                    _investorCount = int.tryParse(value) ?? 0;
                  });
                },
              ),

              // Images (Optional)
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement image upload logic
                  setState(() {
                    _images.add('https://example.com/image.jpg'); // Example
                  });
                },
                child: Text('Add Image (Optional)'),
              ),
              ..._images.map((image) => ListTile(title: Text(image))).toList(),

              // PDF and Video (Optional)
              TextFormField(
                controller: TextEditingController(text: _pdf),
                decoration: InputDecoration(labelText: 'PDF URL (Optional)'),
                onChanged: (value) {
                  setState(() {
                    _pdf = value;
                  });
                },
              ),
              TextFormField(
                controller: TextEditingController(text: _video),
                decoration: InputDecoration(labelText: 'Video URL (Optional)'),
                onChanged: (value) {
                  setState(() {
                    _video = value;
                  });
                },
              ),

              // Save Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _saveProject();
                    Navigator.pop(context); // Go back to dashboard
                  }
                },
                child: Text('Save Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _saveProject() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }

    final entrepreneurId = user.uid;

    final projectData = {
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
      'status': 'Under Review', // Default status
      'entrepreneurId': entrepreneurId, // Link to the entrepreneur
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Add the project and get the document reference
    DocumentReference docRef = await _db.collection('projects').add(projectData);

    // Update the project with its projectId
    await docRef.update({'projectId': docRef.id});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Project saved successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save project: $e')),
    );
  }
}
}