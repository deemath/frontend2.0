import 'dart:async';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/core/providers/auth_provider.dart';

class TokenManagerService {
  // API endpoints
  // Use localhost for mobile, but use the browser host for web
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // In production, this would be your API domain
    } else {
      // For mobile, use platform-specific localhost
      if (Platform.isAndroid) {
        // Use production backend if running as an installed APK (not emulator)
        // You can check for emulator by checking the device model or environment.
        // Here, as a simple approach, use the production URL for Android devices.
        return 'https://backend-nestjs-production-8204.up.railway.app';
        // If you want to distinguish between emulator and real device, you can add more logic here.
      }
      return 'http://localhost:3000'; // iOS simulator or real device
    }
  }

  static const String _refreshEndpoint = '/auth/refresh';

  // Storage keys
  static const String _accessTokenKey = 'access_token';

  // In-memory storage
  String? _accessToken;

  // Storage services
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Dio _dio = Dio();
  final Dio _unauthenticatedDio = Dio();

  // Auth provider reference
  final AuthProvider _authProvider;

  // Constructor with required auth provider
  TokenManagerService(this._authProvider) {
    // Configure Dio to handle cookies
    _configureDio();
    _configureUnauthenticatedDio();
  }

  // Configure Dio with interceptors and cookie handling
  void _configureDio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.connectTimeout = const Duration(seconds: 15);

    // Enable cookies
    _dio.options.extra['withCredentials'] = true;

    // Set additional headers for web vs mobile
    if (kIsWeb) {
      // Important for CORS in web
      _dio.options.headers['Access-Control-Allow-Origin'] = '*';
      _dio.options.headers['Access-Control-Allow-Credentials'] = 'true';
    }

    // Add request interceptor
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // Add authorization header if we have an access token
      if (_accessToken != null) {
        options.headers['Authorization'] = 'Bearer $_accessToken';
      }
      return handler.next(options);
    }, onError: (DioException error, handler) async {
      // Handle 401 errors
      if (error.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await refreshToken();

        if (refreshed) {
          // Retry the original request with the new token
          final opts = error.requestOptions;
          opts.headers['Authorization'] = 'Bearer $_accessToken';

          // Create new request
          final response = await _dio.fetch(opts);
          return handler.resolve(response);
        }
      }

      // Pass the error through if we couldn't handle it
      return handler.next(error);
    }));
  }

  void _configureUnauthenticatedDio() {
    _unauthenticatedDio.options.baseUrl = _baseUrl;
    _unauthenticatedDio.options.receiveTimeout = const Duration(seconds: 15);
    _unauthenticatedDio.options.connectTimeout = const Duration(seconds: 15);
    _unauthenticatedDio.options.extra['withCredentials'] = true;
    if (kIsWeb) {
      _unauthenticatedDio.options.headers['Access-Control-Allow-Origin'] = '*';
      _unauthenticatedDio.options.headers['Access-Control-Allow-Credentials'] =
          'true';
    }
    // No auth interceptors for unauthenticated requests
  }

  // Initialize the service by loading token from storage
  Future<void> initialize() async {
    try {
      print('TokenManagerService: Starting initialization');
      await loadTokenFromStorage();
      print(
          'TokenManagerService: Initialization complete, hasToken: ${hasToken}');
    } catch (e) {
      print('TokenManagerService: Error during initialization: $e');
      rethrow;
    }
  }

  // Load token from storage
  Future<void> loadTokenFromStorage() async {
    if (kIsWeb) {
      // For web, rely primarily on SharedPreferences since secure storage has limitations
      await _loadTokenFromSharedPreferences();
    } else {
      try {
        // For mobile, prefer secure storage
        final accessToken = await _secureStorage.read(key: _accessTokenKey);

        // If token exists, update memory and auth provider
        if (accessToken != null) {
          _accessToken = accessToken;
          _authProvider.setToken(accessToken);

          // Try to refresh token to validate it
          await refreshToken();
        }
      } catch (e) {
        print('Error loading token from storage: $e');
        // Fallback to shared preferences if secure storage fails
        await _loadTokenFromSharedPreferences();
      }
    }
  }

  // Fallback method to load token from SharedPreferences
  Future<void> _loadTokenFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(_accessTokenKey);

      if (accessToken != null) {
        _accessToken = accessToken;
        _authProvider.setToken(accessToken);

        // Try to refresh token to validate it
        await refreshToken();
      }
    } catch (e) {
      print('Error loading token from SharedPreferences: $e');
    }
  }

  // Save access token to both memory and storage
  Future<void> saveAccessToken(String token) async {
    _accessToken = token;

    if (kIsWeb) {
      // For web, use SharedPreferences
      await _saveTokenToSharedPreferences(token);
    } else {
      try {
        // For mobile, prefer secure storage
        await _secureStorage.write(key: _accessTokenKey, value: token);
      } catch (e) {
        print('Error saving token to secure storage: $e');
        // Fallback to SharedPreferences
        await _saveTokenToSharedPreferences(token);
      }
    }

    // Update auth provider
    _authProvider.setToken(token);
  }

  // Fallback method to save token to SharedPreferences
  Future<void> _saveTokenToSharedPreferences(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, token);
    } catch (e) {
      print('Error saving token to SharedPreferences: $e');
    }
  }

  // Clear tokens for logout
  Future<void> clearTokens() async {
    _accessToken = null;

    // Always clear from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);

    // Only clear secure storage on mobile
    if (!kIsWeb) {
      try {
        await _secureStorage.delete(key: _accessTokenKey);
      } catch (e) {
        print('Error clearing tokens from secure storage: $e');
      }
    }

    // Update auth provider
    _authProvider.logout();
  }

  // Get access token
  String? get accessToken => _accessToken;

  // Check if access token exists
  bool get hasToken => _accessToken != null;

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      print('Attempting to refresh token...');

      // Call the refresh endpoint
      final response = await _dio.post(_refreshEndpoint, options: Options(
          // Ensure cookies are sent with the request
          extra: {'withCredentials': true}));

      print('Refresh response status: ${response.statusCode}');

      // Handle successful response
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        // Save the new access token
        if (data['accessToken'] != null) {
          print('Successfully received new access token');
          await saveAccessToken(data['accessToken']);

          // If user data is included, update auth provider
          if (data['user'] != null) {
            print('User data received in refresh response');
            _authProvider.setUser(data['user']);
          }

          return true;
        } else {
          print('Refresh response missing accessToken field: ${response.data}');
        }
      } else {
        print(
            'Unexpected refresh response format or status code: ${response.statusCode}');
      }

      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      if (e is DioException) {
        print(
            'DioException details - Status code: ${e.response?.statusCode}, Message: ${e.message}');
        print('Response data: ${e.response?.data}');
      }

      // Clear tokens if refresh fails with 401
      if (e is DioException && e.response?.statusCode == 401) {
        print('Unauthorized (401) during refresh, clearing tokens');
        await clearTokens();
      }

      return false;
    }
  }

  // Get authenticated Dio instance
  Dio get authenticatedDio => _dio;
  Dio get unauthenticatedDio => _unauthenticatedDio;
}
