import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/onboarding/splash_screen.dart' as splash;
import 'screens/onboarding/email_password.dart' as emailpassword;
import 'screens/onboarding/name_input.dart' as nameInput;
import 'screens/onboarding/age_gender.dart' as ageGender;
import 'screens/onboarding/investor_or_entrepreneur.dart' as roleSelection;
import 'screens/onboarding/home.dart' as home;
import '/screens/auth/login.dart' as login;

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => splash.SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding/name',
      name: 'name-input',
      builder: (context, state) => nameInput.NameInputScreen(),
    ),
GoRoute(
  path: '/onboarding/age-gender',
  name: 'age-gender',
  builder: (context, state) {
    final Map<String, dynamic>? userData = state.extra as Map<String, dynamic>?;
    return ageGender.AgeGenderScreen(
      firstName: userData?['firstName'] ?? '',
      lastName: userData?['lastName'] ?? '',
    );
  },
),
GoRoute(
  path: '/onboarding/role-selection',
  name: 'role-selection',
  builder: (context, state) {
    final Map<String, dynamic>? userData = state.extra as Map<String, dynamic>?;
    return roleSelection.InvestorOrEntrepreneurScreen(
      firstName: userData?['firstName'] ?? '',
      lastName: userData?['lastName'] ?? '',
      dateOfBirth: userData?['dateOfBirth'] ?? DateTime.now(),
      gender: userData?['gender'] ?? '',
    );
  },
),
GoRoute(
  path: '/home',
  name: 'home',
  builder: (context, state) {
    final Map<String, dynamic>? userData = state.extra as Map<String, dynamic>?;
    final String? userRole = userData?['role'];
    final String? userName = userData?['name'];

    return home.HomeScreen(userRole: userRole, userName: userName);
  },
),
GoRoute(
  path: '/onboarding/email-password',
  name: 'email-password',
  builder: (context, state) {
    final Map<String, dynamic>? userData = state.extra as Map<String, dynamic>?;
    return emailpassword.EmailPasswordScreen(
      userRole: userData?['userRole'] ?? 'Investor',
      firstName: userData?['firstName'] ?? '',
      lastName: userData?['lastName'] ?? '',
      dateOfBirth: userData?['dateOfBirth'] ?? DateTime.now(),
      gender: userData?['gender'] ?? '',
    );
  },
),
GoRoute(
  path: '/login',
  name: 'login',
  builder: (context, state) => login.LoginScreen(),
),
  ],
);