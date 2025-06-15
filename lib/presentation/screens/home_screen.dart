import 'package:flutter/material.dart';
import '../../data/services/spotify_service.dart';
import '../../core/constants/app_constants.dart';
import 'bar.dart';
import 'bottom_bar.dart';
import 'playing_bar.dart';

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
      accessToken: widget.accessToken ?? AppConstants.spotifyAccessToken
    );
    _fetchCurrentTrack();
    // Refresh every 5 seconds
    Future.delayed(Duration(seconds: 5), _fetchCurrentTrack);
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
          // Playing bar
          PlayingBar(),
          // Main content below
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.grey[900]!],
                ),
              ),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error: $_errorMessage',
                                style: TextStyle(color: Colors.red, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchCurrentTrack,
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _currentTrack == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No track currently playing',
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _fetchCurrentTrack,
                                    child: Text('Refresh'),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_currentTrack!['item']?['album']?['images']?[0]?['url'] != null)
                                    Container(
                                      width: 300,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 10,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          _currentTrack!['item']['album']['images'][0]['url'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 24),
                                  Text(
                                    _currentTrack!['item']?['name'] ?? 'Unknown Track',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _currentTrack!['item']?['artists']?[0]?['name'] ?? 'Unknown Artist',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.album, color: Colors.grey[400]),
                                      SizedBox(width: 8),
                                      Text(
                                        _currentTrack!['item']?['album']?['name'] ?? 'Unknown Album',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
