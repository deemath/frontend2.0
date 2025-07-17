import 'package:dio/dio.dart';

class RequestService {
  static final Dio _dio = Dio();
  static const String _baseUrl = 'http://localhost:3000';

  static Future<List<Map<String, dynamic>>> getPendingRequests() async {
    try {
      final response = await _dio.get('$_baseUrl/request/pending');
      if (response.statusCode == 200 && response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching requests: $e');
      return [];
    }
  }

  static Future<bool> confirmRequest(String requestSendUserId, String requestReceiveUserId) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/request/confirm',
        data: {
          'requestSendUserId': requestSendUserId,
          'requestReceiveUserId': requestReceiveUserId,
        },
      );
      return response.statusCode == 200 && response.data != null;
    } catch (e) {
      print('Error confirming request: $e');
      return false;
    }
  }
}
