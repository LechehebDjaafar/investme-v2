import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:investme/router.dart';
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
  final _router = router; // Use the defined router

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InvestMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E2A47), // Dark blue
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF4B400)), // Gold
        useMaterial3: true,
      ),
      routerConfig: _router, // Use GoRouter for navigation
    );
  }
}