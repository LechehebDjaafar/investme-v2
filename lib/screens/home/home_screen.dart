import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  final String? userRole; // دور المستخدم (رائد أعمال أو مستثمر)
  final String? userName; // اسم المستخدم

  const HomeScreen({Key? key, this.userRole, this.userName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // مؤشر الصفحة الحالية

  // قائمة الشاشات بناءً على دور المستخدم
  final List<Widget> _screens = [
    Center(child: Text('Dashboard')), // شاشة Dashboard
    Center(child: Text('Messages')), // شاشة الرسائل
    Center(child: Text('Notifications')), // شاشة الإشعارات
    Center(child: Text('Settings')), // شاشة الإعدادات
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "InvestMe",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4A90E2), // أزرق فاتح
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome, ${widget.userName ?? 'User'}!",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // نص أبيض
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.userRole == "Investor"
                        ? "Explore promising startups and invest in the future!"
                        : "Find investors and grow your business!",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70, // نص رمادي فاتح
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // زر اكتشاف المشاريع أو البحث عن مستثمرين
                  ElevatedButton(
                    onPressed: () {
                      if (widget.userRole == "Investor") {
                        context.go('/investor/browse-projects'); // الانتقال إلى شاشة تصفح المشاريع
                      } else {
                        context.go('/entrepreneur/add-project'); // الانتقال إلى شاشة إضافة مشروع
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4B400), // زر ذهبي
                      foregroundColor: Colors.white, // نص أبيض
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.userRole == "Investor" ? "Discover Startups" : "Find Investors",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // عرض الشاشة الحالية بناءً على مؤشر الصفحة
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
      // BottomNavigationBar للتنقل بين الشاشات
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // التنقل بين الشاشات باستخدام GoRouter
          switch (index) {
            case 0:
              context.go('/entrepreneur/dashboard');
              break;
            case 1:
              context.go('/entrepreneur/messages');
              break;
            case 2:
              context.go('/entrepreneur/notifications');
              break;
            case 3:
              context.go('/entrepreneur/settings');
              break;
          }
        },
      ),
    );
  }
}