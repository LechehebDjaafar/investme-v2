import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/onboarding/splash_screen.dart' as splash;
import 'screens/onboarding/email_password.dart' as emailpassword;
import 'screens/onboarding/name_input.dart' as nameInput;
import 'screens/onboarding/age_gender.dart' as ageGender;
import 'screens/onboarding/investor_or_entrepreneur.dart' as roleSelection;
import 'screens/onboarding/home.dart' as home;
import '/screens/auth/login.dart' as login;
import 'screens/entrepreneur/dashboard.dart' as entrepreneurDashboard;
import 'screens/entrepreneur/messages_screen.dart' as entrepreneurMessages;
import 'screens/entrepreneur/notifications_screen.dart' as entrepreneurNotifications;
import 'screens/entrepreneur/settings_screen.dart' as entrepreneurSettings;
// import 'screens/investor/browse_projects.dart' as investorBrowseProjects;
import 'screens/entrepreneur/add_project.dart' as entrepreneurAddProject;

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
    // شاشات رائد الأعمال
    GoRoute(
      path: '/entrepreneur/dashboard',
      name: 'entrepreneur-dashboard',
      builder: (context, state) => entrepreneurDashboard.DashboardScreen(),
    ),
    GoRoute(
      path: '/entrepreneur/messages',
      name: 'entrepreneur-messages',
      builder: (context, state) => entrepreneurMessages.MessagesScreen(),
    ),
    GoRoute(
      path: '/entrepreneur/notifications',
      name: 'entrepreneur-notifications',
      builder: (context, state) => entrepreneurNotifications.NotificationsScreen(),
    ),
    GoRoute(
      path: '/entrepreneur/settings',
      name: 'entrepreneur-settings',
      builder: (context, state) => entrepreneurSettings.SettingsScreen(),
    ),
    GoRoute(
      path: '/entrepreneur/add-project',
      name: 'entrepreneur-add-project',
      builder: (context, state) => entrepreneurAddProject.AddProjectScreen(),
    ),
    // شاشات المستثمر
    // GoRoute(
    //   path: '/investor/browse-projects',
    //   name: 'investor-browse-projects',
    //   builder: (context, state) => investorBrowseProjects.BrowseProjectsScreen(),
    // ),
  ],
);