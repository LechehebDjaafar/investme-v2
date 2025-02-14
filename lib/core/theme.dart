import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: const Color(0xFF1E2A47), // الأزرق الداكن
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFF4B400), // الذهبي
      primary: const Color(0xFF4A90E2), // الأزرق الفاتح
      secondary: const Color(0xFFF4B400), // الذهبي
      background: const Color(0xFF1E2A47), // الأزرق الداكن
    ),
    scaffoldBackgroundColor: const Color(0xFF1E2A47), // خلفية الشاشة
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: Colors.white), // النصوص الأساسية
      bodyMedium: TextStyle(color: const Color(0xFF2C2C2C)), // النصوص الثانوية
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF4B400), // لون الزر الافتراضي (ذهبي)
        foregroundColor: Colors.white, // لون النص
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF4A90E2)),
      ),
    ),
    useMaterial3: true,
  );
}