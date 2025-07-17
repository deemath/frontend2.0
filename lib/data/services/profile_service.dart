import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {
  // Base URL for backend API
  static const String baseUrl = 'http://localhost:3000/profile';

  // Fetch user profile info (username, profileImage, bio, stats)
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // If the backend returns a profile object, use it
        if (data is Map<String, dynamic> && data.containsKey('username')) {
          return {
            'success': true,
            'data': data,
            'message': 'Profile retrieved successfully',
          };
        }
        // If the backend returns a "Profile not found" message
        if (data is Map<String, dynamic> &&
            data['message'] == 'Profile not found') {
          return {
            'success': false,
            'message': 'Profile not found',
            'error': data['error'] ?? '',
          };
        }
        // Otherwise, treat as failed
        return {
          'success': false,
          'message': 'Failed to retrieve profile',
        };
      } else {
        // Try to parse error message from backend
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> &&
            data['message'] == 'Profile not found') {
          return {
            'success': false,
            'message': 'Profile not found',
            'error': data['error'] ?? '',
          };
        }
        return {
          'success': false,
          'message': 'Failed to retrieve profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Fetch user's posts (returns list of post objects)
  Future<List<dynamic>> getUserPosts(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data;
        }
        return [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Fetch user's album images (returns only the list of album image links)
  Future<List<String>> getUserAlbumImages(String userId) async {
    try {
      // Fetch posts and extract albumImage from each post
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          // Extract albumImage from each post, filter out null/empty
          return data
              .map<String?>((post) => post['albumImage']?.toString())
              .where((img) => img != null && img.isNotEmpty)
              .cast<String>()
              .toList();
        }
        return [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Update user profile info
  Future<Map<String, dynamic>> updateProfile(
      String userId, Map<String, dynamic> updateData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updateData),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'] ?? false,
          'message': data['message'] ?? '',
          'profile': data['profile'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Create user profile
  Future<Map<String, dynamic>> createProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profileData),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Profile created successfully',
          'profile': data['profile'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create profile',
          'error': data['error'] ?? '',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }
}
