import 'package:go_router/go_router.dart';
import 'screens/entrepreneur/main_screen.dart';
import 'screens/onboarding/help_screen.dart';
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
import 'screens/entrepreneur/add_project.dart' as entrepreneurAddProject;

// إضافة مستوردات لجزء المستثمر
import 'screens/investor/investor_main_screen.dart' as investorMainScreen;
import 'screens/investor/investor_dashboard.dart' as investorDashboard;
import 'screens/investor/browse_projects.dart' as investorBrowseProjects;
import 'screens/investor/project_details.dart' as investorProjectDetails;
import 'screens/investor/investor_profile.dart' as investorProfile;

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // شاشات التحميل والمساعدة
    GoRoute(
      path: '/',
      builder: (context, state) => splash.SplashScreen(), // Home screen
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => splash.SplashScreen(), // Splash screen
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => HelpScreen(), // Help screen
    ),

    // شاشة تسجيل الدخول
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => login.LoginScreen(),
    ),

    // شاشات التسجيل
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

    // شاشات رائد الأعمال
    GoRoute(
      path: '/entrepreneur/main',
      name: 'entrepreneur-main',
      builder: (context, state) => MainScreen(), // Main screen with BottomNavigationBar
    ),
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
    GoRoute(
      path: '/investor/main',
      name: 'investor-main',
      builder: (context, state) => investorMainScreen.InvestorMainScreen(),
    ),
    GoRoute(
      path: '/investor/dashboard',
      name: 'investor-dashboard',
      builder: (context, state) => investorDashboard.InvestorDashboard(),
    ),
    GoRoute(
      path: '/investor/browse-projects',
      name: 'investor-browse-projects',
      builder: (context, state) => investorBrowseProjects.BrowseProjects(),
    ),
    GoRoute(
      path: '/investor/project-details',
      name: 'investor-project-details',
      builder: (context, state) => investorProjectDetails.ProjectDetails(),
    ),
    GoRoute(
      path: '/investor/profile',
      name: 'investor-profile',
      builder: (context, state) => investorProfile.InvestorProfile(),
    ),
  ],
);