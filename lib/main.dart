import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage/HomePage.dart';
import 'package:frontend/Screens/Onboarding/LanguageScreen.dart';
import 'package:frontend/Screens/Onboarding/LevelScreen.dart';
import 'package:frontend/Screens/Onboarding/LoginScreen.dart';
import 'package:frontend/Screens/Onboarding/SignupScreen.dart';

import 'Screens/Onboarding/onboarding.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyDerc0omMLUFqeASw7Y1zA1bUcNnsg0Ahs',
    appId: '1:1108191260:android:350d327f99bea41fce57d9',
    messagingSenderId: '1108191260',
    projectId: 'kitlang-674dd',
    storageBucket: 'kitlang-674dd.appspot.com',
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: _checkLoginStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return snapshot.data == true
                      ? const HomePage()
                      : const Onboarding();
                }
              },
            ),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/lang': (context) => const LanguageScreen(),
        '/home': (context) => const HomePage(),
        '/level': (context) => const LevelScreen(),
      },
    );
  }

//ignore this code
  static Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    return userId != null;
  }
}
