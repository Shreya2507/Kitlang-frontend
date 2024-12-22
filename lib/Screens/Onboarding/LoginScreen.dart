import 'package:flutter/material.dart';
import 'package:frontend/Screens/Onboarding/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();

  Future<void> _login() async {
    try {
      final result = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/home');
      print('User logged in: $result');
    } catch (e) {
      print('Failed to login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/onboarding/Sign_Up.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/onboarding/Sign_Up.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/onboarding/signup_cat.gif'),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    filled: true,
                    labelText: "Email",
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Type in your email",
                    fillColor: Colors.white70,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20.0),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    filled: true,
                    labelText: "Password",
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Type in your username",
                    fillColor: Colors.white70,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Create Account'),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
