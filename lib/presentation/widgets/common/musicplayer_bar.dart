import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicPlayerControls extends StatelessWidget {
  final bool playing;
  final VoidCallback? onPrevious;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;

  const MusicPlayerControls({
    Key? key,
    required this.playing,
    this.onPrevious,
    this.onPlayPause,
    this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(LucideIcons.skipBack,
              color: Theme.of(context).colorScheme.onPrimary, size: 20),
          onPressed: onPrevious,
        ),
        IconButton(
          icon: Icon(playing ? LucideIcons.pause : LucideIcons.play,
              color: Theme.of(context).colorScheme.onPrimary, size: 20),
          onPressed: onPlayPause,
        ),
        IconButton(
          icon: Icon(LucideIcons.skipForward,
              color: Theme.of(context).colorScheme.onPrimary, size: 20),
          onPressed: onNext,
        ),
      ],
    );
  }
}

class MusicPlayerBar extends StatefulWidget {
  final String authToken;

  const MusicPlayerBar({
    Key? key,
    required this.authToken,
  }) : super(key: key);

  @override
  _MusicPlayerBarState createState() => _MusicPlayerBarState();
}

class _MusicPlayerBarState extends State<MusicPlayerBar> {
  String _trackName = 'No track playing';
  String _artistName = '';
  bool _isPlaying = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchCurrentTrack();

    // Initialize the refresh timer
    _resetRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchCurrentTrack() async {
    // Only fetch if we have an auth token
    if (widget.authToken.isEmpty) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/spotify/player/current-track'),
        headers: {
          'Authorization': 'Bearer ${widget.authToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (mounted) {
          setState(() {
            // Update playing state
            _isPlaying = data['is_playing'] ?? false;

            // Check if we have track data
            if (data['track'] != null) {
              _trackName = data['track']['name'] ?? 'Unknown Track';

              if (data['track']['artists'] != null &&
                  (data['track']['artists'] as List).isNotEmpty) {
                _artistName = data['track']['artists'][0];
              } else {
                _artistName = 'Unknown Artist';
              }
            } else {
              // If no track playing or track information is not available
              _trackName = "It's silent in here...";
              _artistName = "";
              // Ensure playback status is consistent
              _isPlaying = false;
            }
          });
        }
      } else {
        print('Failed to load current track: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching current track: $e');
    }
  }

  // Helper method to reset and restart the refresh timer
  void _resetRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _fetchCurrentTrack();
    });
  }

  Future<void> _togglePlayback() async {
    // Only proceed if we have an auth token
    if (widget.authToken.isEmpty) {
      return;
    }

    try {
      // If currently playing, pause the track; otherwise resume
      final endpoint = _isPlaying
          ? 'http://localhost:3000/spotify/player/pause'
          : 'http://localhost:3000/spotify/player/play';

      final response = _isPlaying
          ? await http.put(
              Uri.parse(endpoint),
              headers: {
                'Authorization': 'Bearer ${widget.authToken}',
                'Content-Type': 'application/json',
              },
            )
          : await http.post(
              Uri.parse(endpoint),
              headers: {
                'Authorization': 'Bearer ${widget.authToken}',
                'Content-Type': 'application/json',
              },
              body: '{}', // Empty JSON object for resuming playback
            );

      if (response.statusCode == 200) {
        // Immediately update UI state for better responsiveness
        setState(() {
          _isPlaying = !_isPlaying; // Toggle the playing state directly
        });

        // Fetch the current track to ensure UI is in sync with Spotify
        Future.delayed(const Duration(milliseconds: 500), _fetchCurrentTrack);

        // Reset the refresh timer to start counting from now
        _resetRefreshTimer();
      } else {
        print(
            'Failed to ${_isPlaying ? 'pause' : 'resume'} playback: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling playback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 5.0,
            offset: Offset(0, -1),
          ),
        ],
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Now Playing" text removed
            Text(
              _trackName,
              style: TextStyle(
                // Change color to purple when playing, regular theme color when paused
                color: _isPlaying
                    ? Colors.purple
                    : Theme.of(context).colorScheme.onPrimary,
                fontSize: 13,
                fontWeight: _isPlaying
                    ? FontWeight.w800
                    : FontWeight.w600, // More bold text
                letterSpacing: _isPlaying
                    ? 0.3
                    : 0.0, // Slightly increase letter spacing when playing
              ),
            ),
            if (_artistName.isNotEmpty)
              Text(_artistName,
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.8),
                      fontSize: 11)),
          ],
        ),
        // Only show controls if we have an actual track (not the placeholder message)
        if (_trackName != "It's silent in here...")
          MusicPlayerControls(
            playing: _isPlaying,
            onPrevious: () {
              // Previous track functionality could be implemented in the future
              _resetRefreshTimer(); // Reset timer when button is pressed
              _fetchCurrentTrack(); // Fetch updated track info immediately
            },
            onPlayPause: () {
              _togglePlayback();
              // Timer is already reset in _togglePlayback method
            },
            onNext: () {
              // Next track functionality could be implemented in the future
              _resetRefreshTimer(); // Reset timer when button is pressed
              _fetchCurrentTrack(); // Fetch updated track info immediately
            },
          ),
      ]),
    );
  }
}
