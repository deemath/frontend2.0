import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  static const String baseUrl = 'http://localhost:3000/search';

  Future<List<Map<String, dynamic>>> search(String query) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$query'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
