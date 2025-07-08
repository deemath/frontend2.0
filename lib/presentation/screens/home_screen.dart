import 'package:flutter/material.dart';
import '/presentation/widgets/home/bar.dart';
import '/presentation/widgets/common/bottom_bar.dart';

// Imports commented out during initial shell implementation
// import '/data/services/spotify_service.dart';
// import '/core/constants/app_constants.dart';
// import '/presentation/widgets/song_post/feed.dart';
// import '/presentation/widgets/common/musicplayer_bar.dart';

class HomeScreen extends StatefulWidget {
  final String? accessToken;

  /// Whether this screen is being displayed inside the ShellScreen.
  /// When true, navigation elements (app bar, bottom bar, music player) are not shown
  /// as they are already provided by the ShellScreen.
  final bool inShell;

  const HomeScreen({Key? key, this.accessToken, this.inShell = false})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Service and state variables commented out during initial shell implementation
  // late final SpotifyService _spotifyService;
  // Map<String, dynamic>? _currentTrack;
  // bool _isLoading = true;
  // String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Spotify service initialization commented out for initial shell implementation
    // _spotifyService = SpotifyService(
    //     accessToken: widget.accessToken ?? AppConstants.spotifyAccessToken);
    // _fetchCurrentTrack();
    // Future.delayed(const Duration(seconds: 5), _fetchCurrentTrack);
  }

  // Method commented out during initial shell implementation
  // Will be re-enabled in future phases
  /*
  Future<void> _fetchCurrentTrack() async {
    try {
      final track = await _spotifyService.getCurrentTrack();
      print('Response from Spotify: $track');

      if (mounted) {
        setState(() {
          _currentTrack = track;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      print('Error fetching track: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    // Simplified content for initial shell implementation
    // Original content commented out for future reference
    Widget content = const Center(
      child: Text(
        'Home Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    // COMMENTED OUT FOR SIMPLICITY DURING INITIAL IMPLEMENTATION
    // Widget content = _isLoading
    //     ? const Center(child: CircularProgressIndicator())
    //     : _errorMessage != null
    //         ? Center(child: Text('Error: $_errorMessage'))
    //         : FeedPage();

    // When in shell mode, only render the content without navigation elements
    if (widget.inShell) {
      return content;
    }

    // LEGACY NAVIGATION SUPPORT - This code will eventually be removed
    // when all screens are migrated to the ShellScreen
    return Scaffold(
      // OLD NAVIGATION: App bar will be provided by ShellScreen in the future
      appBar: NootAppBar(),
      body: Column(
        children: [
          Expanded(
            child: content,
          ),
          // COMMENTED OUT MUSIC PLAYER FOR SIMPLICITY
          // MusicPlayerBar(
          //   title: _currentTrack != null ? _currentTrack!['name'] ?? 'Unknown' : 'Bluestar',
          //   playing: false
          // ),
        ],
      ),
      // OLD NAVIGATION: Bottom bar will be provided by ShellScreen in the future
      bottomNavigationBar: const BottomBar(),
    );
    // END LEGACY NAVIGATION SUPPORT
  }
}
