import 'package:flutter/material.dart';
import 'router.dart'; // استيراد ملف router.dart
import 'core/theme.dart'; // استيراد Thema

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InvestMe',
      debugShowCheckedModeBanner: false,
      theme: appTheme(), // استخدام Thema المخصص
      routerConfig: _router,
    );
  }
}