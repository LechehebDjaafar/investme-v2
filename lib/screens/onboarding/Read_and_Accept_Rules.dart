import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ReadAndAcceptRulesScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ReadAndAcceptRulesScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  _ReadAndAcceptRulesScreenState createState() => _ReadAndAcceptRulesScreenState();
}

class _ReadAndAcceptRulesScreenState extends State<ReadAndAcceptRulesScreen> {
  bool isAgreed = false; // علامة لتحديد إذا كان المستخدم قد وافق على القواعد
  List<bool> ruleChecks = []; // قائمة لتتبع حالة اختيار كل قاعدة

  @override
  void initState() {
    super.initState();
    // ملء القائمة بقيم false بناءً على عدد القواعد
    ruleChecks = List.generate(_getRules(widget.userData['userRole']).length, (_) => false);
  }

  // تحقق مما إذا كانت جميع القواعد تم اختيارها
  bool areAllRulesAccepted() {
    return ruleChecks.every((isChecked) => isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // خلفية بيضاء
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر العودة
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: const Color(0xFF032D64)), // أزرق داكن
                onPressed: () {
                  context.go('/onboarding/role-selection'); // العودة إلى صفحة اختيار الدور
                },
              ),
            ),
            const SizedBox(height: 20),
            // عنوان الصفحة
            Text(
              "Read and Accept Rules",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF032D64), // أزرق داكن
              ),
            ),
            const SizedBox(height: 10),
            // وصف الصفحة
            Text(
              "Please read the rules carefully before proceeding.",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF49AEEF), // أزرق فاتح
              ),
            ),
            const SizedBox(height: 20),
            // عرض القواعد
            Expanded(
              child: ListView.builder(
                itemCount: _getRules(widget.userData['userRole']).length + 1, // +1 للخيار "Select All"
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // الخيار الأول: Select All
                    return _buildSelectAllCheckbox();
                  } else {
                    // عرض القواعد الفردية
                    return _buildRuleItem(index - 1); // index - 1 لأن Select All هو الأول
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // زر الموافقة
            ElevatedButton(
              onPressed: areAllRulesAccepted()
                  ? () {
                      // الانتقال إلى صفحة البريد الإلكتروني والباسورد مع تمرير البيانات
                      context.go(
                        '/onboarding/email-password',
                        extra: {
                          'userRole': widget.userData['userRole'],
                          'firstName': widget.userData['firstName'],
                          'lastName': widget.userData['lastName'],
                          'dateOfBirth': widget.userData['dateOfBirth'],
                          'gender': widget.userData['gender'],
                        },
                      );
                    }
                  : null, // تعطيل الزر إذا لم يتم الموافقة على جميع القواعد
              style: ElevatedButton.styleFrom(
                backgroundColor: areAllRulesAccepted() ? const Color(0xFF065A94) : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "I Agree",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // عرض القواعد بناءً على الدور
  List<String> _getRules(String? userRole) {
    if (userRole == "Investor") {
      return [
        "Commit to local and international investment laws.",
        "Provide accurate and truthful information about your investments.",
        "Respect the privacy of entrepreneurs' data.",
        "Be transparent in all financial transactions.",
        "Avoid harassment or inappropriate behavior.",
        "Adhere to the agreed terms of investment.",
        "Support entrepreneurs with advice and guidance."
      ];
    } else if (userRole == "Entrepreneur") {
      return [
        "Present accurate and reliable information about your project.",
        "Respect the rights of investors and their share in the project.",
        "Maintain open communication with investors.",
        "Commit to deadlines and timelines.",
        "Provide clear and transparent financial reports.",
        "Focus on innovation and development of the project.",
        "Adhere to platform policies and guidelines."
      ];
    } else {
      return [];
    }
  }

  // عرض خيار "Select All"
  Widget _buildSelectAllCheckbox() {
    return ListTile(
      leading: Checkbox(
        value: areAllRulesAccepted(),
        onChanged: (value) {
          setState(() {
            for (int i = 0; i < ruleChecks.length; i++) {
              ruleChecks[i] = value ?? false;
            }
          });
        },
      ),
      title: Text(
        "Select All",
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: const Color(0xFF032D64), // أزرق داكن
        ),
      ),
    );
  }

  // عرض كل قاعدة
  Widget _buildRuleItem(int index) {
    String rule = _getRules(widget.userData['userRole'])[index];
    return ListTile(
      leading: Checkbox(
        value: ruleChecks[index],
        onChanged: (value) {
          setState(() {
            ruleChecks[index] = value ?? false;
          });
        },
      ),
      title: Text(
        rule,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: const Color(0xFF032D64), // أزرق داكن
        ),
      ),
    );
  }
}