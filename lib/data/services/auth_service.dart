import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Update this to your actual backend URL
  static const String baseUrl = 'http://localhost:3000/auth';
  
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Store access token from Authorization header
        final authHeader = response.headers['authorization'];
        if (authHeader != null) {
          final accessToken = authHeader.replaceFirst('Bearer ', '');
          await _storeAccessToken(accessToken);
        }
        
        // Store user data
        await _storeUserData(data['user']);
        
        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Login successful',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? errorData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Registration successful',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? errorData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> loginWithSpotify() async {
    try {
      // TODO: Implement Spotify OAuth login
      // This should redirect to Spotify OAuth and handle the callback
      
      // For now, return a placeholder response
      return {
        'success': false,
        'message': 'Spotify login coming soon',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Spotify login error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> signupWithSpotify() async {
    try {
      // TODO: Implement Spotify OAuth signup
      // This should redirect to Spotify OAuth and handle the callback
      
      // For now, return a placeholder response
      return {
        'success': false,
        'message': 'Spotify signup coming soon',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Spotify signup error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Clear stored tokens and user data
        await _clearStoredData();
        
        return {
          'success': true,
          'message': 'Logout successful',
        };
      } else {
        return {
          'success': false,
          'message': 'Logout failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Store new access token from Authorization header
        final authHeader = response.headers['authorization'];
        if (authHeader != null) {
          final accessToken = authHeader.replaceFirst('Bearer ', '');
          await _storeAccessToken(accessToken);
        }
        
        // Store updated user data
        await _storeUserData(data['user']);
        
        return {
          'success': true,
          'data': data,
          'message': 'Token refreshed',
        };
      } else {
        return {
          'success': false,
          'message': 'Token refresh failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Helper methods for storing/retrieving tokens and user data
  Future<void> _storeAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _storeUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final userData = await getUserData();
    return token != null && userData != null;
  }

  Future<void> _clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_data');
  }
}