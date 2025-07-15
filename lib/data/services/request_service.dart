import 'package:dio/dio.dart';

class RequestService {
  static final Dio _dio = Dio();
  static const String _baseUrl = 'http://localhost:3000';

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await _dio.get('$_baseUrl/request/users');
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.statusCode == 200 && response.data is Map && response.data['users'] != null) {
      
        return List<Map<String, dynamic>>.from(response.data['users']);
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
}
