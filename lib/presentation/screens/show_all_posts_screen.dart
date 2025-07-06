import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/services/song_post_service.dart';
import '../../data/services/spotify_service.dart';
import '../../data/models/post_model.dart';
import '../../core/constants/app_constants.dart';

class ShowAllPostsScreen extends StatefulWidget {
  const ShowAllPostsScreen({Key? key}) : super(key: key);

  @override
  State<ShowAllPostsScreen> createState() => _ShowAllPostsScreenState();
}

class _ShowAllPostsScreenState extends State<ShowAllPostsScreen> {
  final SongPostService _songPostService = SongPostService();
  final SpotifyService _spotifyService = SpotifyService(
    accessToken: AppConstants.spotifyAccessToken,
  );
  
  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;
  String? _currentlyPlayingTrackId;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadPosts(); // Load posts when the screen is initialized
  }

  // Load posts from the backend
  Future<void> _loadPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final result = await _songPostService.getAllPosts();
      
      if (result['success']) {
        final List<dynamic> postsData = result['data'];
        final posts = postsData.map((json) => Post.fromJson(json)).toList();
        
        setState(() {
          _posts = posts;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading posts: $e';
        _isLoading = false;
      });
    }
  }

//main screen layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF667eea),
      appBar: AppBar(
        title: const Text('Music Feed', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadPosts,
          ),
        ],
      ),
      body: _buildContent(),
    );
  }


//what to show on the screen
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPosts,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, color: Colors.white, size: 48),
            SizedBox(height: 16),
            Text('No posts yet', style: TextStyle(color: Colors.white, fontSize: 18)),
            Text('Be the first to share your favorite music!', 
                 style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(_posts[index]);
        },
      ),
    );
  }


//how each post looks
  Widget _buildPostCard(Post post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF667eea),
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${post.songName} • ${post.artists}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_currentlyPlayingTrackId == post.trackId && _isPlaying)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Playing', style: TextStyle(color: Colors.green, fontSize: 10)),
                  ),
                const SizedBox(width: 8),
                Text(_formatTimestamp(post.createdAt), style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          
          // Album image
          if (post.albumImage != null && post.albumImage!.isNotEmpty)
            Container(
              width: double.infinity,
              height: 200,
              child: Image.network(
                post.albumImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.music_note, size: 64, color: Colors.grey),
                  );
                },
              ),
            ),
          
          // Caption
          if (post.caption != null && post.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(post.caption!),
            ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border,
                  label: '${post.likes}',
                  onTap: () => _handleLike(post),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.comments}',
                  onTap: () => _handleComment(post),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: _currentlyPlayingTrackId == post.trackId && _isPlaying 
                      ? Icons.pause_circle_outline 
                      : Icons.play_circle_outline,
                  label: _currentlyPlayingTrackId == post.trackId && _isPlaying ? 'Pause' : 'Play',
                  onTap: () => _handlePlay(post),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.share,
                  label: '',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _handleLike(Post post) {
    // TODO: Implement like functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Liked ${post.songName}')),
    );
  }

  void _handleComment(Post post) {
    // TODO: Implement comment functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comment on ${post.songName}')),
    );
  }

  Future<void> _handlePlay(Post post) async {
    if (_currentlyPlayingTrackId == post.trackId && _isPlaying) {
      await _pausePlayback();
    } else {
      await _playTrack(post);
    }
  }

  Future<void> _playTrack(Post post) async {
    try {
      final result = await _spotifyService.playTrack(post.trackId);
      
      if (result['success']) {
        setState(() {
          _currentlyPlayingTrackId = post.trackId;
          _isPlaying = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Now playing: ${post.songName}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to play track')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing track: $e')),
      );
    }
  }

  Future<void> _pausePlayback() async {
    try {
      final result = await _spotifyService.pausePlayback();
      
      if (result['success']) {
        setState(() {
          _isPlaying = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playback paused')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to pause')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error pausing playback: $e')),
      );
    }
  }



  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
} 