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
              color: onPrevious == null
                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                  : Theme.of(context).colorScheme.onPrimary,
              size: 20),
          onPressed: onPrevious,
        ),
        IconButton(
          icon: Icon(playing ? LucideIcons.pause : LucideIcons.play,
              color: onPlayPause == null
                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                  : Theme.of(context).colorScheme.onPrimary,
              size: 20),
          onPressed: onPlayPause,
        ),
        IconButton(
          icon: Icon(LucideIcons.skipForward,
              color: onNext == null
                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                  : Theme.of(context).colorScheme.onPrimary,
              size: 20),
          onPressed: onNext,
        ),
      ],
    );
  }
}

class MusicPlayerBar extends StatefulWidget {
  final String authToken;
  // Add a callback to expose active session state
  final void Function(bool isActive)? onSessionStatusChanged;
  // Track whether the widget is visually hidden
  final bool isHidden;

  const MusicPlayerBar({
    Key? key,
    required this.authToken,
    this.onSessionStatusChanged,
    this.isHidden = false,
  }) : super(key: key);

  @override
  _MusicPlayerBarState createState() => _MusicPlayerBarState();
}

class _MusicPlayerBarState extends State<MusicPlayerBar> {
  String _trackName = 'No track playing';
  String _artistName = '';
  bool _isPlaying = false;
  bool _controlsLocked = false;
  bool _hasActiveSession = false;
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

  @override
  void didUpdateWidget(MusicPlayerBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If the visibility state changed, adjust our timer frequency
    if (oldWidget.isHidden != widget.isHidden) {
      _resetRefreshTimer();
    }
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
          // Get the top-level is_playing status to determine if there's an active session
          final bool isActiveSession = data['is_playing'] ?? false;
          
          setState(() {
            // Store the active session status
            _hasActiveSession = isActiveSession;

            // Check if we have track data and an active session
            if (data['track'] != null && _hasActiveSession) {
              // Update track information
              _trackName = data['track']['name'] ?? 'Unknown Track';

              if (data['track']['artists'] != null &&
                  (data['track']['artists'] as List).isNotEmpty) {
                _artistName = data['track']['artists'][0];
              } else {
                _artistName = 'Unknown Artist';
              }

              // Use track.is_playing for the actual play/pause state
              _isPlaying = data['track']['is_playing'] ?? false;
            } else {
              // If no track playing or track information is not available
              _trackName = "It's silent in here...";
              _artistName = "";
              // Ensure playback status is consistent
              _isPlaying = false;
            }

            // Unlock controls after receiving an update from the backend
            _controlsLocked = false;
          });
          
          // Notify parent widget about session status change
          if (widget.onSessionStatusChanged != null) {
            widget.onSessionStatusChanged!(_hasActiveSession);
          }
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
    // Use a more frequent check interval when widget is hidden to detect new sessions faster
    final interval = widget.isHidden ? const Duration(seconds: 3) : const Duration(seconds: 5);
    
    _refreshTimer = Timer.periodic(interval, (_) {
      // Always fetch track data regardless of visibility
      _fetchCurrentTrack();
    });
  }

  Future<void> _skipToPreviousTrack() async {
    // Only proceed if we have an auth token and controls are not locked
    if (widget.authToken.isEmpty || _controlsLocked) {
      return;
    }

    // Lock controls to prevent spamming
    setState(() {
      _controlsLocked = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/spotify/player/previous'),
        headers: {
          'Authorization': 'Bearer ${widget.authToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Cancel the previous timer to avoid conflicting updates
        _refreshTimer?.cancel();

        // Immediately fetch the current track to get the updated track info
        _fetchCurrentTrack();

        // Also restart the periodic timer after a short delay
        _refreshTimer = Timer(const Duration(seconds: 2), () {
          // Fetch again after giving Spotify servers time to update
          _fetchCurrentTrack();
          // Then restart the periodic timer
          _resetRefreshTimer();
        });
      } else {
        // Unlock controls in case of error
        setState(() {
          _controlsLocked = false;
        });
        print('Failed to skip to previous track: ${response.statusCode}');
      }
    } catch (e) {
      // Unlock controls in case of error
      setState(() {
        _controlsLocked = false;
      });
      print('Error skipping to previous track: $e');
    }
  }

  Future<void> _skipToNextTrack() async {
    // Only proceed if we have an auth token and controls are not locked
    if (widget.authToken.isEmpty || _controlsLocked) {
      return;
    }

    // Lock controls to prevent spamming
    setState(() {
      _controlsLocked = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/spotify/player/next'),
        headers: {
          'Authorization': 'Bearer ${widget.authToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Cancel the previous timer to avoid conflicting updates
        _refreshTimer?.cancel();

        // Immediately fetch the current track to get the updated track info
        _fetchCurrentTrack();

        // Also restart the periodic timer after a short delay
        _refreshTimer = Timer(const Duration(seconds: 2), () {
          // Fetch again after giving Spotify servers time to update
          _fetchCurrentTrack();
          // Then restart the periodic timer
          _resetRefreshTimer();
        });
      } else {
        // Unlock controls in case of error
        setState(() {
          _controlsLocked = false;
        });
        print('Failed to skip to next track: ${response.statusCode}');
      }
    } catch (e) {
      // Unlock controls in case of error
      setState(() {
        _controlsLocked = false;
      });
      print('Error skipping to next track: $e');
    }
  }

  Future<void> _togglePlayback() async {
    // Only proceed if we have an auth token and controls are not locked
    if (widget.authToken.isEmpty || _controlsLocked) {
      return;
    }

    // Lock controls to prevent spamming
    setState(() {
      _controlsLocked = true;
    });

    try {
      // Determine which action to take based on current playback state
      final shouldPause = _isPlaying;
      final endpoint = shouldPause
          ? 'http://localhost:3000/spotify/player/pause'
          : 'http://localhost:3000/spotify/player/play';

      final response = shouldPause
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
        // Cancel the previous timer to avoid conflicting updates
        _refreshTimer?.cancel();

        // Immediately fetch the current track to get the actual play state
        _fetchCurrentTrack();

        // Also restart the periodic timer after a short delay
        _refreshTimer = Timer(const Duration(seconds: 2), () {
          // Fetch again after giving Spotify servers time to update
          _fetchCurrentTrack();
          // Then restart the periodic timer
          _resetRefreshTimer();
        });
      } else {
        // Unlock controls in case of error
        setState(() {
          _controlsLocked = false;
        });
        print(
            'Failed to ${shouldPause ? 'pause' : 'resume'} playback: ${response.statusCode}');
      }
    } catch (e) {
      // Unlock controls in case of error
      setState(() {
        _controlsLocked = false;
      });
      print('Error toggling playback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // The widget still builds and makes API calls even when hidden,
    // but we apply visual adjustments when it's hidden
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: BoxDecoration(
        boxShadow: widget.isHidden 
            ? [] // No shadow when hidden
            : [
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
        // Only show controls if we have an active session with a track
        if (_trackName != "It's silent in here..." && _hasActiveSession)
          MusicPlayerControls(
            playing: _isPlaying,
            onPrevious: _controlsLocked
                ? null
                : () {
                    _skipToPreviousTrack();
                  },
            onPlayPause: _controlsLocked
                ? null
                : () {
                    _togglePlayback();
                    // Timer is already reset in _togglePlayback method
                  },
            onNext: _controlsLocked
                ? null
                : () {
                    _skipToNextTrack();
                  },
          ),
      ]),
    );
  }
}
