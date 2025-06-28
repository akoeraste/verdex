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
import 'services/language_service.dart';
import 'services/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  debugPrint('🚀 [App] Verdex app starting...');

  final languageService = LanguageService();
  final connectivityService = ConnectivityService();

  // Initialize connectivity service
  await connectivityService.initialize();

  debugPrint('🚀 [App] Connectivity service initialized');
  debugPrint(
    '🚀 [App] Current connection status: ${connectivityService.isConnected ? "ONLINE" : "OFFLINE"}',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => languageService),
        ChangeNotifierProvider(create: (_) => connectivityService),
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
        scaffoldBackgroundColor: const Color(0xFFF9FBE7),
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

    // Load language and set locale
    final languageService = Provider.of<LanguageService>(
      context,
      listen: false,
    );
    await languageService.loadSavedLanguage();
    await context.setLocale(Locale(languageService.majorLanguageCode));

    debugPrint(
      '🚀 [App] Language loaded: ${languageService.majorLanguageCode}',
    );

    // Check permissions
    final cameraStatus = await Permission.camera.status;
    final photosStatus = await Permission.photos.status;
    final permissionsGranted = cameraStatus.isGranted && photosStatus.isGranted;

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

    // Navigate to the splash screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SplashScreen(permissionsGranted: permissionsGranted),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
