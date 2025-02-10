// Import the dart async library for Timer
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:programming_app/providers/editor_navigation_provider.dart';
import 'package:programming_app/providers/file_provider.dart';
import 'package:programming_app/providers/folder_provider.dart';
import 'package:programming_app/providers/login_provider.dart';
import 'package:programming_app/providers/navigation_provider.dart';
import 'package:programming_app/providers/signup_provider.dart';
import 'package:programming_app/providers/theme_provider.dart';
import 'package:programming_app/providers/user_provider.dart';
import 'package:programming_app/screens/intializing%20screens/login_screen.dart';
import 'package:programming_app/screens/intializing%20screens/splash_screen.dart'; // Import the splash screen
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Enable offline persistence for Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => FolderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FileProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EditorNavigationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Programming App',
          theme: themeProvider.currentTheme,
          routes: {
            '/login': (context) => LoginScreen(),
          },
          // Show SplashScreen first, then AuthScreen
          home: const SplashScreen(),
        );
      },
    );
  }
}
