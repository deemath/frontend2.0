import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../core/providers/auth_provider.dart';
import 'token_manager_service.dart';

class AuthService {
  final AuthProvider authProvider;
  late TokenManagerService _tokenManager;

  // Constructor now requires authProvider
  AuthService(this.authProvider) {
    _tokenManager = TokenManagerService(authProvider);
  }

  // Initialize the service and check for stored tokens
  Future<void> initialize() async {
    try {
      await _tokenManager.initialize();
    } catch (e) {
      debugPrint('Error initializing AuthService: $e');
      rethrow;
    }
  }

  // Get the token manager for direct access when needed
  TokenManagerService get tokenManager => _tokenManager;

  // Login with credentials and handle token storage
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _tokenManager.unauthenticatedDio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final String? token = responseData['accessToken'];

        if (token != null) {
          // Save token to secure storage and memory
          await _tokenManager.saveAccessToken(token);

          // Update user data in auth provider
          authProvider.setUser(responseData['user']);

          // Return both token and user data
          return {
            'success': true,
            'user': responseData['user'],
            'token': token,
            'message': responseData['message'] ?? 'Login successful'
          };
        } else {
          return {'success': false, 'message': 'Token not found in response'};
        }
      } else {
        return {
          'success': false,
          'message':
              response.data['message'] ?? 'Login failed. Please try again.'
        };
      }
    } on DioException catch (e) {
      debugPrint('Login error: ${e.message}');
      // Check for specific error responses
      if (e.response != null) {
        return {
          'success': false,
          'message':
              e.response?.data?['message'] ?? 'Login failed. Please try again.'
        };
      }
      return {
        'success': false,
        'message':
            'Connection error. Please check your connection and try again.'
      };
    } catch (e) {
      debugPrint('Login error: $e');
      return {
        'success': false,
        'message':
            'An error occurred. Please check your connection and try again.'
      };
    }
  }

  // Logout and clear tokens
  Future<Map<String, dynamic>> logout() async {
    try {
      // Attempt to call logout endpoint
      try {
        await _tokenManager.authenticatedDio.post('/auth/logout');
      } catch (_) {
        // Ignore errors from the logout endpoint
      }

      // Clear tokens regardless of API call success
      await _tokenManager.clearTokens();

      return {'success': true, 'message': 'Logged out successfully'};
    } catch (e) {
      debugPrint('Logout error: $e');
      // Still attempt to clear tokens even if there was an error
      try {
        await _tokenManager.clearTokens();
      } catch (_) {}

      return {'success': false, 'message': 'Error during logout'};
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => authProvider.isAuthenticated;

  // Get authenticated Dio instance for API calls
  Dio get dio => _tokenManager.authenticatedDio;
}
