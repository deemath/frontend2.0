import 'package:flutter/material.dart';
import '/data/services/spotify_service.dart';
// import '../../data/services/spotify_service.dart';
import '/core/constants/app_constants.dart';
import '/presentation/widgets/home/bar.dart';
import '/presentation/widgets/common/bottom_bar.dart';

import '/presentation/widgets/song_post/feed.dart';
import '/presentation/widgets/common/musicplayer_bar.dart';

class HomeScreen extends StatefulWidget {
  final String? accessToken;

  const HomeScreen({Key? key, this.accessToken}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SpotifyService _spotifyService;
  Map<String, dynamic>? _currentTrack;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _spotifyService = SpotifyService(
        accessToken: widget.accessToken ?? AppConstants.spotifyAccessToken);
    _fetchCurrentTrack();
    // Refresh every 5 seconds
    Future.delayed(const Duration(seconds: 5), _fetchCurrentTrack);
  }

  Future<void> _fetchCurrentTrack() async {
    try {
      final track = await _spotifyService.getCurrentTrack();
      print('Response from Spotify: $track');

      setState(() {
        _currentTrack = track;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      print('Error fetching track: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NootAppBar(),
      body: Column(
        children: [
          Expanded(
            child: FeedPage(),
          ),
          MusicPlayerBar(title: 'Bluestar', playing: false),
        ],
      ),
      // Bottom bar
      bottomNavigationBar: const BottomBar(),
    );
  }
}
