import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/entrepreneur/main_screen.dart'; // استيراد إعدادات Firebase
 // استيراد MainScreen (BottomNavigationBar)

void main() async {
  // تهيئة Firebase
  WidgetsFlutterBinding.ensureInitialized(); // ضمان تهيئة Flutter
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // إعدادات Firebase
  );

  // تشغيل التطبيق
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvestMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E2A47), // الأزرق الداكن
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF4B400)), // الذهبي
        useMaterial3: true,
      ),
      home: MainScreen(), // شاشة BottomNavigationBar كشاشة رئيسية
    );
  }
}