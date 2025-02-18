import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking
import 'dart:io'; // For File handling
import 'dart:convert'; // For base64 encoding

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _expectedCompletionDateController = TextEditingController();

  double _completionPercentage = 0;
  double _currentAmount = 0;
  int _investorCount = 0;
  List<String> _images = [];
  String _pdf = '';
  String _video = '';

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image and convert it to Base64
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      setState(() {
        _images.add(base64Encode(bytes)); // Convert image to Base64 and add to list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F0FE), // خلفية عامة
      appBar: AppBar(
        backgroundColor: Color(0xFF2196F3), // أزرق داكن غني
        title: Text('Add New Project', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // اسم المشروع
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  labelStyle: TextStyle(color: Color(0xFF42A5F5)), // نصوص ثانوية
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // زوايا مستديرة
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF2196F3)), // أزرق مشرق
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // الفئة
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF2196F3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // الوصف
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF2196F3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // المبلغ المستهدف
              TextFormField(
                controller: _targetAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Target Amount',
                  labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF2196F3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid target amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // تاريخ الإكمال المتوقع
              TextFormField(
                controller: _expectedCompletionDateController,
                decoration: InputDecoration(
                  labelText: 'Expected Completion Date',
                  labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF2196F3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
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
              SizedBox(height: 16),

              // نسبة الإكمال
              Slider(
                value: _completionPercentage,
                min: 0,
                max: 100,
                divisions: 100,
                activeColor: Color(0xFF2196F3), // أزرق مشرق
                inactiveColor: Colors.grey.shade300,
                onChanged: (double value) {
                  setState(() {
                    _completionPercentage = value;
                  });
                },
              ),
              Text(
                'Completion Percentage: ${_completionPercentage.round()}%',
                style: TextStyle(fontSize: 14, color: Color(0xFF42A5F5)),
              ),
              SizedBox(height: 16),

              // المبلغ الحالي
              Slider(
                value: _currentAmount,
                min: 0,
                max: double.tryParse(_targetAmountController.text.isNotEmpty
                        ? _targetAmountController.text
                        : '0') ??
                    0,
                divisions: 100,
                activeColor: Color(0xFF2196F3),
                inactiveColor: Colors.grey.shade300,
                onChanged: (double value) {
                  setState(() {
                    _currentAmount = value;
                  });
                },
              ),
              Text(
                'Current Amount: $_currentAmount',
                style: TextStyle(fontSize: 14, color: Color(0xFF42A5F5)),
              ),
              SizedBox(height: 16),

              // عدد المستثمرين
              TextFormField(
                initialValue: '0',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Investor Count',
                  labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF2196F3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _investorCount = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 16),

              // إضافة صور
              ElevatedButton(
                onPressed: _pickImage, // Call the image picker function
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // زوايا مستديرة
                  ),
                  elevation: 4, // ظل خفيف
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Add Image (Optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (_images.isNotEmpty)
                Column(
                  children: _images.map((image) => ListTile(
                    title: Text('Image added'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _images.remove(image); // Remove image from list
                        });
                      },
                    ),
                  )).toList(),
                ),
              SizedBox(height: 16),

              // رابط PDF وفيديو
              TextFormField(
                controller: TextEditingController(text: _pdf),
                decoration: InputDecoration(
                  labelText: 'PDF URL (Optional)',
                  labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF2196F3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _pdf = value;
                  });
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: TextEditingController(text: _video),
                decoration: InputDecoration(
                  labelText: 'Video URL (Optional)',
                  labelStyle: TextStyle(color: Color(0xFF42A5F5)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF2196F3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _video = value;
                  });
                },
              ),
              SizedBox(height: 24),

              // زر الحفظ
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _saveProject();
                    Navigator.pop(context); // Go back to dashboard
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // زوايا مستديرة
                  ),
                  elevation: 4, // ظل خفيف
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Save Project',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
          'images': _images, // Save images as Base64 strings
          'pdf': _pdf,
          'video': _video,
        },
        'status': 'Under Review', // Default status
        'entrepreneurId': entrepreneurId, // Link to the entrepreneur
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      DocumentReference docRef = await _db.collection('projects').add(projectData);
      await docRef.update({'projectId': docRef.id});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project saved successfully!', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF00C853), // أخضر فاتح
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save project: $e', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}