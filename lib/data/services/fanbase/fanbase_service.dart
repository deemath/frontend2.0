// import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../core/providers/auth_provider.dart';
import '../../models/fanbase/fanbase_model.dart';
import '../auth_service.dart';

class FanbaseService {
  static Future<List<Fanbase>> getAllFanbases(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      final response = await dio.get('/fanbase');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Fanbase.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load fanbases');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load fanbases: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load fanbases: $e');
    }
  }

  static Future<Fanbase> getFanbaseById(String id, BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      final response = await dio.get('/fanbase/$id');

      if (response.statusCode == 200) {
        return Fanbase.fromJson(response.data);
      } else {
        throw Exception('Fanbase not found');
      }
    } on DioException catch (e) {
      throw Exception('Fanbase not found: ${e.message}');
    } catch (e) {
      throw Exception('Fanbase not found: $e');
    }
  }

  static Future<void> createFanbase(
      String name, String topic, BuildContext context,
      {File? imageFile, String? imageUrl}) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      if (!authProvider.isAuthenticated || authProvider.token == null) {
        throw Exception('Authentication required. Please log in.');
      }

      // Prepare form data
      final formData = FormData.fromMap({
        'fanbaseName': name,
        'topic': topic,
      });

      // Add image file if provided
      if (imageFile != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ));
      } else if (imageUrl != null && imageUrl.isNotEmpty) {
        formData.fields.add(MapEntry('fanbasePhotoUrl', imageUrl));
      }

      final response = await dio.post(
        '/fanbase',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create fanbase: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication failed. Please log in again.');
      } else {
        final errorMessage =
            e.response?.data?.toString() ?? e.message ?? 'Unknown error';
        throw Exception('Failed to create fanbase: $errorMessage');
      }
    } catch (e) {
      throw Exception('Failed to create fanbase: $e');
    }
  }

  static Future<Fanbase> joinFanbase(
      String fanbaseId, BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      final response = await dio.post('/fanbase/$fanbaseId/join');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Fanbase.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to update join status: ${response.statusMessage}');
      }

    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception('Failed to update join status: $errorMessage');

    } catch (e) {
      throw Exception('Failed to update join status: $e');
    }
  }

  static Future<Fanbase> likeFanbase(
      String fanbaseId, BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;

      final response = await dio.post('/fanbase/$fanbaseId/like');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Fanbase.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to update like status: ${response.statusMessage}');
      }

    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception('Failed to update like status: $errorMessage');

    } catch (e) {
      throw Exception('Failed to update like status: $e');
    }
  }
}
