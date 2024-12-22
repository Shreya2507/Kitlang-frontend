import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Onboarding/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _apiService = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  bool _isLoading = false;
  String? _errorMessage;
  String? _userId;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.register(
        _emailController.text,
        _passwordController.text,
        _usernameController.text,
      );
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to register: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Sign in aborted by user.';
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user != null) {
        await _saveUserToFirestore(user.email!, _passwordController.text);

        Navigator.pushReplacementNamed(context, '/lang');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign in failed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserToFirestore(String email, String password) async {
    const url = 'http://127.0.0.1:8080/auth/create-user'; // Adjust if necessary

    final body = json.encode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _userId = jsonResponse['user_id'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to save user data: ${response.statusCode}, ${response.body}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/onboarding/Sign_Up.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/onboarding/signup_cat.gif'),
                    ),
                  ),
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _signInWithGoogle,
                        icon: Image.asset(
                          'assets/onboarding/google_logo.png',
                          height: 15.0,
                        ),
                        label: const Text(
                          'Sign up with Google',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                if (_userId != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    'User created successfully with ID: $_userId',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.black)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or Continue with Email',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    filled: true,
                    labelText: "Username",
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Type in your username",
                    fillColor: Colors.white70,
                  ),
                  controller: _usernameController,
                ),
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
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Create Account'),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login.',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
