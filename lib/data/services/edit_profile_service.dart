import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/edit_profile_model.dart';

class EditProfileService {
  static const String baseUrl = 'http://localhost:3000/profile';

  Future<Map<String, dynamic>> updateProfile(
      String userId, EditProfileModel profile) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJson()),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Profile updated successfully'};
      } else {
        return {'success': false, 'message': 'Failed to update profile'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
