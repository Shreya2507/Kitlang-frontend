import 'dart:convert';
import 'package:frontend/redux/actions.dart';
import 'package:frontend/redux/appstate.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:uno/uno.dart';

class ApiService {
  final Logger _logger = Logger();
  final uno = Uno();
  String? _userId;

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String username,
  ) async {
    const url = 'https://saran-2021-kitlang-authentication.hf.space/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'username': username,
        }),
      );

      if (response.statusCode == 200) {
        _logger.i('Registration successful: ${response.body}');
        return jsonDecode(response.body);
      } else {
        _logger.e('Failed to register user: ${response.body}');
        throw Exception('Failed to register user');
      }
    } catch (e) {
      _logger.e('Error during registration: $e');
      rethrow;
    }
  }

  Future<void> login(
    String email,
    String password,
    Store<AppState> store,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://saran-2021-kitlang-authentication.hf.space/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userId = data['userId'];

        _logger.i('Login successful: $userId');

        // Dispatch action to update Redux store
        store.dispatch(SetUserIdAction(userId));
      } else {
        _logger.e('Failed to log in: ${response.body}');
        throw Exception('Failed to log in');
      }
    } catch (e) {
      _logger.e('Error during login: $e');
      rethrow;
    }
  }

  final String baseUrl = 'http://192.168.1.73:8000/auth';

  Future<void> registerWithGoogle(
    String googleToken,
    Store<AppState> store,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.73:8000/auth/google-signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': googleToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userId = data['userId'];

        _logger.i('Google Sign-In successful: $userId');

        // Dispatch action to update Redux store
        store.dispatch(SetUserIdAction(userId));
        print('✅ User ID dispatched to Redux: $userId');
      } else {
        _logger.e('Failed to sign in with Google: ${response.body}');
        throw Exception('Failed to sign in with Google');
      }
    } catch (e) {
      _logger.e('Error during Google Sign-In: $e');
      rethrow;
    }
  }
}
