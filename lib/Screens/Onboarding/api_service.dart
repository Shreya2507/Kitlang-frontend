import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:uno/uno.dart';

class ApiService {
  final Logger _logger = Logger();
  final uno = Uno();

  Future<Map<String, dynamic>> register(
      String email, String password, String username) async {
    const url = 'http://192.168.1.11:8000/auth/register';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
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

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.11:8000/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        _logger.i('Login successful: ${response.body}');
        return jsonDecode(response.body);
      } else {
        _logger.e('Failed to log in: ${response.body}');
        throw Exception('Failed to log in');
      }
    } catch (e) {
      _logger.e('Error during login: $e');
      rethrow;
    }
  }

  final String baseUrl = 'http://192.168.1.11:8000/auth';

  Future<Map<String, dynamic>> registerWithGoogle(
      String email, String displayName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'displayName': displayName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register with Google: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
