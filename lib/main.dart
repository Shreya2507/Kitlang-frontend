import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage/HomePage.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const Onboarding(),
    );
  }
}
