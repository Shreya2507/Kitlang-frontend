import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage/HomePage.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();  // Initialize Firebase asynchronously

    // Verify Firebase connection by checking default app
    final FirebaseApp app = Firebase.app();
    print('Firebase app initialized: ${app.name}');

    runApp(MyApp());
  } catch (e) {
    // Handle initialization errors
    print('🔥 Firebase initialization error: $e');
    runApp(FirebaseErrorWidget(error: e));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Your main screen
    );
  }
}

// Fallback widget for Firebase errors
class FirebaseErrorWidget extends StatelessWidget {
  final Object error;

  const FirebaseErrorWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 50),
              SizedBox(height: 20),
              Text(
                'Firebase Connection Failed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await Firebase.initializeApp();
                    runApp(MyApp());
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Retry failed: $e')),
                    );
                  }
                },
                child: Text('Retry Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
