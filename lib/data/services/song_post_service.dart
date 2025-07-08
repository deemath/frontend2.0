import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SongPostService {
  // Update this to your actual backend URL
  static const String baseUrl = 'http://localhost:3000/song-posts';
  
  Future<Map<String, dynamic>> createPost({
    required String trackId,
    required String songName,
    required String artists,
    String? albumImage,
    String? caption,
  }) async {
    try {
      // Get user data from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      
      // Commented out user login checking for testing
      // if (userDataString == null) {
      //   return {
      //     'success': false,
      //     'message': 'User not logged in',
      //   };
      // }
      
      // final userData = jsonDecode(userDataString);
      
      // For testing, use dummy user data
      final userData = {
        '_id': '685fb750cc084ba7e0ef8533',
        'username': 'owl'
      };
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'trackId': trackId,
          'songName': songName,
          'artists': artists,
          'albumImage': albumImage,
          'caption': caption,
          'userId': userData['_id'],
          'username': userData['username'],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Post created successfully',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? errorData['message'] ?? 'Failed to create post',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getAllPosts() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'Posts retrieved successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to retrieve posts',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getPostsByUserId(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
          'message': 'User posts retrieved successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to retrieve user posts',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> likePost(String postId, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$postId/like'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    return jsonDecode(response.body);
  }
} 