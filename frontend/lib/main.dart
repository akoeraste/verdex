import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/main_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/identify_screen.dart';
import 'screens/debug_screen.dart';
import 'services/language_service.dart';
import 'services/connectivity_service.dart';
import 'services/performance_monitor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize performance monitoring
  final performanceMonitor = PerformanceMonitor();
  performanceMonitor.startTimer('app_startup');

  // Run critical initializations in parallel
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    _initializeServices(),
  ]);

  debugPrint('🚀 [App] Verdex app starting...');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageService()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    ),
  );
}

// Initialize services in parallel for faster startup
Future<void> _initializeServices() async {
  final performanceMonitor = PerformanceMonitor();

  return await performanceMonitor.timeOperation(
    'services_initialization',
    () async {
      final connectivityService = ConnectivityService();
      await connectivityService.initialize();

      debugPrint('🚀 [App] Services initialized');
      debugPrint(
        '🚀 [App] Current connection status: ${connectivityService.isConnected ? "ONLINE" : "OFFLINE"}',
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🚀 [App] Building main app widget');

    return MaterialApp(
      title: 'Verdex',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4CAF50),
          foregroundColor: Colors.white,
        ),
      ),
      home: const AppInitializer(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const MainScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/identify': (context) => const IdentifyScreen(),
        '/debug': (context) => const DebugScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    debugPrint('🚀 [App] AppInitializer initState called');
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    debugPrint('🚀 [App] Starting app initialization...');

    final performanceMonitor = PerformanceMonitor();

    // Run non-critical initializations in parallel
    final results = await Future.wait([
      _loadLanguageSettings(),
      _checkPermissions(),
    ]);

    final languageCode = results[0] as String;
    final permissionsGranted = results[1] as bool;

    debugPrint('🚀 [App] Language loaded: $languageCode');
    debugPrint(
      '🚀 [App] Permissions status: ${permissionsGranted ? "GRANTED" : "NOT GRANTED"}',
    );

    // Get connectivity status
    final connectivityService = Provider.of<ConnectivityService>(
      context,
      listen: false,
    );

    debugPrint(
      '🚀 [App] Final connectivity status: ${connectivityService.isConnected ? "ONLINE" : "OFFLINE"}',
    );
    debugPrint(
      '🚀 [App] App initialization complete, navigating to splash screen',
    );

    // Complete startup timer
    performanceMonitor.stopTimer('app_startup');
    performanceMonitor.printPerformanceSummary();

    // Navigate to the splash screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SplashScreen(permissionsGranted: permissionsGranted),
        ),
      );
    }
  }

  Future<String> _loadLanguageSettings() async {
    final performanceMonitor = PerformanceMonitor();
    return await performanceMonitor.timeOperation('language_loading', () async {
      final languageService = Provider.of<LanguageService>(
        context,
        listen: false,
      );
      await languageService.loadSavedLanguage();
      await context.setLocale(Locale(languageService.majorLanguageCode));
      return languageService.majorLanguageCode;
    });
  }

  Future<bool> _checkPermissions() async {
    final performanceMonitor = PerformanceMonitor();
    return await performanceMonitor.timeOperation(
      'permissions_check',
      () async {
        final cameraStatus = await Permission.camera.status;
        final photosStatus = await Permission.photos.status;
        return cameraStatus.isGranted && photosStatus.isGranted;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
