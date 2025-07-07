import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../core/providers/auth_provider.dart';

class AuthService {
  final String _baseUrl = 'http://localhost:3000';
  final AuthProvider? authProvider;

  AuthService({this.authProvider});

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String? token = responseData['accessToken'];

        if (token != null) {
          // Update AuthProvider if it's available
          if (authProvider != null) {
            authProvider!.login(responseData['user'], token);
          }

          // Return both token and user data
          return {
            'success': true,
            'user': responseData['user'],
            'token': token,
            'message': responseData['message']
          };
        } else {
          return {
            'success': false,
            'message': 'Token not found in response headers'
          };
        }
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Login failed. Please try again.'
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return {
        'success': false,
        'message':
            'An error occurred. Please check your connection and try again.'
      };
    }
  }
}
