// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import '../../core/providers/auth_provider.dart';
import '../models/fanbase_post_model.dart';
import 'auth_service.dart';

class FanbasePostService {
  final String baseUrl = 'http://localhost:3000';

  // Add these methods to the existing FanbaseService class:

// Add import at the top

// Add these methods to the existing FanbaseService class:

  // Create a fanbase post
  static Future<FanbasePost> createFanbasePost({
    required String fanbaseId,
    required String topic,
    required String description,
    String? spotifyTrackId,
    String? songName,
    String? artistName,
    String? albumArt,
    required BuildContext context,
  }) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      final postData = {
        'topic': topic.trim(),
        'description': description.trim(),
        'fanbaseId': fanbaseId,
        if (spotifyTrackId != null) 'spotifyTrackId': spotifyTrackId,
        if (songName != null) 'songName': songName,
        if (artistName != null) 'artistName': artistName,
        if (albumArt != null) 'albumArt': albumArt,
      };

      final response = await dio.post('/fanbase/posts', data: postData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FanbasePost.fromJson(response.data);
      } else {
        throw Exception('Failed to create post: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception('Failed to create post: $errorMessage');
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Get posts for a fanbase
  static Future<List<FanbasePost>> getFanbasePosts(
    String fanbaseId,
    BuildContext context, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      final response = await dio.get(
        '/fanbase/$fanbaseId/posts',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['posts'] ?? response.data;
        return data.map((json) => FanbasePost.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch posts');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch posts: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  // Like/Unlike a fanbase post
  static Future<FanbasePost> likeFanbasePost(
    String postId,
    BuildContext context,
  ) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      final response = await dio.post('/fanbase/posts/$postId/like');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FanbasePost.fromJson(response.data);
      } else {
        throw Exception('Failed to like post: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception('Failed to like post: $errorMessage');
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  // Add comment to a fanbase post
  static Future<FanbasePost> addComment(
    String postId,
    String comment,
    BuildContext context,
  ) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      final response = await dio.post('/fanbase/posts/$postId/comment', data: {
        'comment': comment.trim(),
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FanbasePost.fromJson(response.data);
      } else {
        throw Exception('Failed to add comment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception('Failed to add comment: $errorMessage');
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Get a specific fanbase post
  static Future<FanbasePost> getFanbasePost(
    String postId,
    BuildContext context,
  ) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      final response = await dio.get('/fanbase/posts/$postId');

      if (response.statusCode == 200) {
        return FanbasePost.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch post');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch post: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch post: $e');
    }
  }
}
