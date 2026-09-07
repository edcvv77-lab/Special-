import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth_provider.dart';
import 'providers/habit_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Need valid Firebase config for a real app.
  // We initialize it here without options, which requires standard flutterfire configure or options provided.
  // For the sake of this prototype and testing locally without actual configs, we wrap in try-catch
  try {
    await Firebase.initializeApp();
    await NotificationService().init();
  } catch (e) {
    print("Firebase initialization failed. Proceeding for UI mockups: \$e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
      ],
      child: const KhasApp(),
    ),
  );
}

class KhasApp extends StatelessWidget {
  const KhasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'خاص',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
      ],
      locale: const Locale('ar', 'SA'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50), // Calm Green
          primary: const Color(0xFF4CAF50),
          secondary: const Color(0xFF81C784),
          background: const Color(0xFFF5F5F5), // Calm off-white
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFFF5F5F5),
          foregroundColor: Colors.black87,
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}
