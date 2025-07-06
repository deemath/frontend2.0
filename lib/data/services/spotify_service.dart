import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class SpotifyService {
  final String accessToken;

  SpotifyService({required this.accessToken});

  Future<Map<String, dynamic>?> getCurrentTrack() async {
    try {
      print('Making request to Spotify API...'); 
      final response = await http.get(
        Uri.parse('${AppConstants.spotifyBaseUrl}/me/player/currently-playing'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        
      );

      print('Response status code: ${response.statusCode}'); 
      print('Response body: ${response.body}');

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
      print('Error in getCurrentTrack: $e'); 
      throw Exception('Error getting current track: $e');
    }
  }

  Future<Map<String, dynamic>> searchTracks(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await http.get(
        Uri.parse('${AppConstants.spotifyBaseUrl}/search?q=$encodedQuery&type=track,artist&limit=10'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Access token expired or invalid. Please refresh your token.');
      } else {
        throw Exception('Failed to search tracks: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in searchTracks: $e');
      throw Exception('Error searching tracks: $e');
    }
  }

  Future<Map<String, dynamic>> playTrack(String trackId) async {
    try {
      print('Attempting to play track: $trackId');
      
      // First, check if user has an active device
      final devicesResponse = await http.get(
        Uri.parse('${AppConstants.spotifyBaseUrl}/me/player/devices'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (devicesResponse.statusCode != 200) {
        return {
          'success': false,
          'message': 'Failed to get devices: ${devicesResponse.statusCode}',
        };
      }

      final devicesData = json.decode(devicesResponse.body);
      final devices = devicesData['devices'] as List;
      
      if (devices.isEmpty) {
        return {
          'success': false,
          'message': 'No active Spotify devices found. Please open Spotify on any device.',
        };
      }

      // Use the first available device
      final deviceId = devices.first['id'];
      
      // Play the track
      final response = await http.put(
        Uri.parse('${AppConstants.spotifyBaseUrl}/me/player/play?device_id=$deviceId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'uris': ['spotify:track:$trackId'],
        }),
      );

      print('Play response status: ${response.statusCode}');
      print('Play response body: ${response.body}');

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Track started playing successfully',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Access token expired or invalid. Please refresh your token.',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'No active device found. Please open Spotify on any device.',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to play track: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      print('Error in playTrack: $e');
      return {
        'success': false,
        'message': 'Error playing track: $e',
      };
    }
  }

  Future<Map<String, dynamic>> pausePlayback() async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.spotifyBaseUrl}/me/player/pause'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Playback paused successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to pause playback: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error pausing playback: $e',
      };
    }
  }

  Future<Map<String, dynamic>> resumePlayback() async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.spotifyBaseUrl}/me/player/play'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Playback resumed successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to resume playback: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error resuming playback: $e',
      };
    }
  }
} 