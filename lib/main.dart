import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // استيراد إعدادات Firebase
import 'router.dart'; // استيراد Router

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
  final _router = router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InvestMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E2A47), // الأزرق الداكن
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF4B400)), // الذهبي
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}