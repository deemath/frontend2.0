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
        // Always extract the profile object if present
        final profile =
            (data is Map<String, dynamic> && data.containsKey('profile'))
                ? data['profile']
                : data;
        if (profile is Map<String, dynamic> &&
            profile.containsKey('username')) {
          return {
            'success': true,
            'data': profile,
            'message': 'Profile retrieved successfully',
          };
        }
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
      } else {
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

  // Fetch user's post stats (likes/comments for each post)
  Future<List<dynamic>> getUserPostStats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/post-stats/$userId'),
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

  // Fetch user post count
  Future<Map<String, dynamic>?> getUserPostCount(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/post_count'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Should contain userId and postCount
        if (data is Map<String, dynamic> && data.containsKey('postCount')) {
          return data;
        }
        return {'userId': userId, 'postCount': 0};
      }
      return {'userId': userId, 'postCount': 0};
    } catch (e) {
      return {'userId': userId, 'postCount': 0};
    }
  }

  // Fetch followers with username and profileImage
  Future<List<dynamic>> getFollowersListWithDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/followers'),
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

  // Fetch following with username and profileImage
  Future<List<dynamic>> getFollowingListWithDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/following'),
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
}
