import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/Screens/Onboarding/services/api_service.dart';
import 'package:frontend/redux/actions.dart';
import 'package:frontend/redux/appstate.dart';
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
    scopes: ['email', 'https://www.googleapis.com/auth/userinfo.profile'],
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
      await _apiService.register(
        _emailController.text,
        _passwordController.text,
        _usernameController.text,
      );

      if (mounted) {
        Navigator.pushNamed(context, '/login');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to register: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserToFirestore(
    String email,
    String password,
    String displayName,
  ) async {
    const url =
        'https://saran-2021-kitlang-authentication.hf.space/auth/create-user';

    final body = json.encode({
      'email': email,
      'password': password,
      'displayName': displayName,
    });

    try {
      print('Sending Request to: $url');
      print('Request Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _userId = jsonResponse['user_id'];
        });

        // ✅ Save userId in Redux
        if (_userId != null) {
          StoreProvider.of<AppState>(
            context,
            listen: false,
          ).dispatch(SetUserIdAction(_userId!));

          print('✅ User ID from API saved in Redux: $_userId');
        }

        print('✅ User ID from API saved in Redux: $_userId');
      } else {
        setState(() {
          _errorMessage =
              'Failed to save user data: ${response.statusCode}, ${response.body}';
        });
      }
    } catch (e) {
      print('Exception: $e');
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
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

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null && user.email != null) {
        // Check if user already exists in Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // User already exists, just store ID and navigate
          StoreProvider.of<AppState>(
            context,
            listen: false,
          ).dispatch(SetUserIdAction(user.uid));

          print('✅ User already exists, ID dispatched: ${user.uid}');
          Navigator.pushReplacementNamed(context, '/lang');
        } else {
          // User does not exist, create new entry
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'displayName': user.displayName ?? "DefaultName",
            'createdAt': FieldValue.serverTimestamp(),
          });

          StoreProvider.of<AppState>(
            context,
            listen: false,
          ).dispatch(SetUserIdAction(user.uid));

          print('✅ New user created and ID dispatched: ${user.uid}');
          Navigator.pushReplacementNamed(context, '/lang');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign in failed: $e';
      });
    } finally {
      setState(() {
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/onboarding/signup_cat.gif'),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _signInWithGoogle,
                        // icon: Image.asset(
                        //   'asset/onboarding/google_logo.png',
                        //   height: 15.0,
                        // ),
                        label: const Text('Sign up with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                      ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (_userId != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'User created successfully with ID: $_userId',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.black)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Or Continue with Email'),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 30),
                _buildTextField(_usernameController, "Username"),
                _buildTextField(_emailController, "Email"),
                _buildTextField(
                  _passwordController,
                  "Password",
                  isPassword: true,
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
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Already have an account? Login.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          labelText: label,
          fillColor: Colors.white70,
          filled: true,
        ),
      ),
    );
  }
}
