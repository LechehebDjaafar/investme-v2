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
      backgroundColor: Color(0xFFE8F0FE), // خلفية عامة
      appBar: AppBar(
        backgroundColor: Color(0xFF2196F3), // أزرق داكن غني
        title: Text('Edit Project', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // حقل اسم المشروع
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
            ),
            SizedBox(height: 16),

            // حقل الفئة
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
            ),
            SizedBox(height: 16),

            // وصف المشروع
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
            ),
            SizedBox(height: 16),

            // شريط التقدم
            Slider(
              value: _completionPercentage,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_completionPercentage.round()}%',
              activeColor: Color(0xFF2196F3), // أزرق مشرق
              inactiveColor: Colors.grey.shade300,
              onChanged: (double value) {
                setState(() {
                  _completionPercentage = value;
                });
              },
            ),
            SizedBox(height: 24),

            // زر الحفظ
            ElevatedButton(
              onPressed: () async {
                await _updateProject();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // زوايا مستديرة
                ),
                elevation: 4, // ظل خفيف
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
      // تحديث المشروع باستخدام projectId
      await _db.collection('projects').doc(widget.project['projectId']).update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project updated successfully!', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF00C853), // أخضر فاتح
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('Failed to update project: $e', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        ),
      );
    }
  }
}