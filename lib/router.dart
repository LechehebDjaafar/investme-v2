import 'package:go_router/go_router.dart';
import 'screens/entrepreneur/main_screen.dart';
import 'screens/investor/ivestme_EditProfile.dart' as EditPro;
import 'screens/investor/profile-entrepreneur.dart' as EntrepreneurPro;
import 'screens/onboarding/Read_and_Accept_Rules.dart'
    as ReadAndAcceptRulesScreen;
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
import 'screens/entrepreneur/notifications_screen.dart'
    as entrepreneurNotifications;
import 'splashscreen.dart' as splash1; // Removed incorrect import
// إضافة مستوردات لجزء المستثمر
import 'screens/investor/investor_main_screen.dart' as investorMainScreen;
import 'screens/investor/investor_dashboard.dart' as investorDashboard;
import 'screens/investor/browse_projects.dart' as investorBrowseProjects;
import 'screens/investor/project_details.dart' as investorProjectDetails;
import 'screens/investor/investor_profile.dart' as investorProfile;

final GoRouter router = GoRouter(
  initialLocation: '/', // البداية تكون من الشاشة الأولى (Splash Screen)
  routes: [
    // ================== General Screens ==================
    // شاشة التحميل (Splash Screen)
    GoRoute(
      path: '/',
      builder: (context, state) => splash1.SplashScreen(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => splash.SplashScreen(),
    ),

    // شاشة المساعدة (Help Screen)
    GoRoute(
      path: '/help',
      builder: (context, state) => HelpScreen(),
    ),

    // شاشة تسجيل الدخول (Login Screen)
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => login.LoginScreen(),
    ),

    // ================== Onboarding Screens ==================
    // شاشة إدخال الاسم (Name Input)
    GoRoute(
      path: '/onboarding/name',
      name: 'name-input',
      builder: (context, state) => nameInput.NameInputScreen(),
    ),

    // شاشة العمر والجنس (Age and Gender)
    GoRoute(
      path: '/onboarding/age-gender',
      name: 'age-gender',
      builder: (context, state) {
        final Map<String, dynamic>? userData =
            state.extra as Map<String, dynamic>?;
        return ageGender.AgeGenderScreen(
          firstName: userData?['firstName'] ?? '',
          lastName: userData?['lastName'] ?? '',
        );
      },
    ),

    // شاشة اختيار الدور (Investor or Entrepreneur)
    GoRoute(
      path: '/onboarding/role-selection',
      name: 'role-selection',
      builder: (context, state) {
        // استخراج البيانات من extra
        final Map<String, dynamic>? userData =
            state.extra as Map<String, dynamic>?;
        return roleSelection.InvestorOrEntrepreneurScreen(
          // تصحيح اسم الصفحة
          firstName: userData?['firstName'] ?? '',
          lastName: userData?['lastName'] ?? '',
          dateOfBirth: userData?['dateOfBirth'] ?? DateTime.now(),
          gender: userData?['gender'] ?? '',
        );
      },
    ),
GoRoute(
  path: '/onboarding/read-and-accept-rules',
  name: 'read-and-accept-rules',
  builder: (context, state) {
    // استخراج البيانات من extra
    final Map<String, dynamic>? userData = state.extra as Map<String, dynamic>?;
    return ReadAndAcceptRulesScreen.ReadAndAcceptRulesScreen(
      userData: userData ?? {}, // تجنب الأخطاء إذا كانت البيانات فارغة
    );
  },
),

    // شاشة البريد الإلكتروني وكلمة المرور (Email Password)
    GoRoute(
      path: '/onboarding/email-password',
      name: 'email-password',
      builder: (context, state) {
        final Map<String, dynamic>? userData =
            state.extra as Map<String, dynamic>?;
        return emailpassword.EmailPasswordScreen(
          userRole: userData?['userRole'] ?? 'Investor',
          firstName: userData?['firstName'] ?? '',
          lastName: userData?['lastName'] ?? '',
          dateOfBirth: userData?['dateOfBirth'] ?? DateTime.now(),
          gender: userData?['gender'] ?? '',
        );
      },
    ),

    // شاشة الرئيسية بعد اختيار الدور (Home Screen)
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        final Map<String, dynamic>? userData =
            state.extra as Map<String, dynamic>?;
        final String? userRole = userData?['role'];
        final String? userName = userData?['name'];

        if (userRole == null || userName == null) {
          return splash
              .SplashScreen(); // إعادة التوجيه إلى Splash Screen إذا لم يكن هناك دور أو اسم
        }

        return home.HomeScreen(userRole: userRole, userName: userName);
      },
    ),

    // ================== Entrepreneur Screens ==================
    // شاشة رائد الأعمال الرئيسية (Main Screen)
    GoRoute(
      path: '/entrepreneur/main',
      name: 'entrepreneur-main',
      builder: (context, state) => MainScreen(),
    ),

    // داشبورد رائد الأعمال (Dashboard)
    GoRoute(
      path: '/entrepreneur/dashboard',
      name: 'entrepreneur-dashboard',
      builder: (context, state) => entrepreneurDashboard.DashboardScreen(),
    ),

    // رسائل رائد الأعمال (Messages)
    GoRoute(
      path: '/entrepreneur/messages',
      name: 'entrepreneur-messages',
      builder: (context, state) => entrepreneurMessages.MessagesScreen(),
    ),

    // إشعارات رائد الأعمال (Notifications)
    GoRoute(
      path: '/entrepreneur/notifications',
      name: 'entrepreneur-notifications',
      builder: (context, state) =>
          entrepreneurNotifications.NotificationsScreen(),
    ),

    // ================== Investor Screens ==================
    // شاشة المستثمر الرئيسية (Main Screen)
    GoRoute(
      path: '/investor/main',
      name: 'investor-main',
      builder: (context, state) => investorMainScreen.InvestorMainScreen(),
    ),

    // داشبورد المستثمر (Dashboard)
    GoRoute(
      path: '/investor/dashboard',
      name: 'investor-dashboard',
      builder: (context, state) => investorDashboard.InvestorDashboard(),
    ),

    // استعراض المشاريع (Browse Projects)
    GoRoute(
      path: '/investor/browse-projects',
      name: 'investor-browse-projects',
      builder: (context, state) => investorBrowseProjects.BrowseProjects(),
    ),

    // تفاصيل المشروع (Project Details)
    GoRoute(
      path: '/investor/project-details',
      name: 'investor-project-details',
      builder: (context, state) {
        final String projectId = state.extra as String;
        return investorProjectDetails.ProjectDetails(projectId: projectId);
      },
    ),

    // ملف المستثمر الشخصي (Profile)
    GoRoute(
      path: '/investor/profile',
      name: 'investor-profile',
      builder: (context, state) => investorProfile.InvestorProfile(),
    ),
    GoRoute(
      path: '/investor/ivestme_EditProfile.dart',
      name: 'ivestme_EditProfile.dart',
      builder: (context, state) => EditPro.EditProfile(),
    ),
    GoRoute(
      path: '/investor/profile-entrepreneur',
      name: 'profile-entrepreneur',
      builder: (context, state) {
        final String entrepreneurId = state.extra as String;
        return EntrepreneurPro.EntrepreneurProfile(
            entrepreneurId: entrepreneurId);
      },
    ),
  ],
);
