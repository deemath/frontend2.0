//(manages API calls)
// Handles all communication with the backend server through HTTP requests
// Provides methods to fetch posts and create new posts
// Includes error handling for network requests and response processing

import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String baseUrl = 'https://api.spotify.com/v1';
  final String accessToken;

  SpotifyService({required this.accessToken});

  Future<Map<String, dynamic>?> getCurrentTrack() async {
    try {
      print('Making request to Spotify API...'); // Debug print
      final response = await http.get(
        Uri.parse('$baseUrl/me/player/currently-playing'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 204) {
        // No track is currently playing
        return null;
      } else if (response.statusCode == 401) {
        throw Exception('Access token expired or invalid. Please refresh your token.');
      } else {
        throw Exception('Failed to get current track: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getCurrentTrack: $e'); // Debug print
      throw Exception('Error getting current track: $e');
    }
  }
}
