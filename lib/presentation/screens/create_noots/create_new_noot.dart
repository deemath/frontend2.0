import 'package:flutter/material.dart';
import '../../widgets/common/musicplayer_bar.dart';
import '../../../data/services/song_post_service.dart';
import 'create_noot_preview.dart';

class CreateNewNootPage extends StatefulWidget {
  final Map<String, dynamic> track;

  const CreateNewNootPage({Key? key, required this.track}) : super(key: key);

  @override
  State<CreateNewNootPage> createState() => _CreateNewNootPageState();
}

class _CreateNewNootPageState extends State<CreateNewNootPage> {
  final TextEditingController _captionController = TextEditingController();
  final SongPostService _songPostService = SongPostService();
  bool _isLoading = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final track = widget.track;
      final String trackId = track['id'] ?? '';
      final String songName = track['name'] ?? '';
      final String artists = track['artists'] is List
          ? track['artists'].join(", ")
          : track['artists'].toString();
      final String? albumImage = track['album'];
      final String caption = _captionController.text.trim();

      
     
      //print('trackId: $trackId');
      //print('songName: $songName');
      //print('artists: $artists');
      //print('albumImage: $albumImage');
     // print('caption: $caption');
     

      final result = await _songPostService.createPost(
        trackId: trackId,
        songName: songName,
        artists: artists,
        albumImage: albumImage,
        caption: caption.isNotEmpty ? caption : null,
      );

      
      //print('=== DEBUG: API Response ===');
      //print('Result: $result');
     

      if (result['success'] == true) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Post created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back to home screen
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to create post'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      //print('=== DEBUG: Exception caught ===');
      //print('Error: $e');
      //print('Error type: ${e.runtimeType}');
     
      
      if (mounted) {
        String errorMessage = 'Unknown error occurred';
        
        if (e.toString().contains('404') || e.toString().contains('Not Found')) {
          errorMessage = 'API endpoint not found. Please check your server configuration.';
        } else if (e.toString().contains('Connection refused')) {
          errorMessage = 'Cannot connect to server. Please check if your backend is running.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Request timed out. Please try again.';
        } else {
          errorMessage = 'Error: ${e.toString()}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPreview() {
    final track = widget.track;
    final String songName = track['name'] ?? '';
    final String artists = track['artists'] is List
        ? track['artists'].join(", ")
        : track['artists'].toString();
    final String? albumImage = track['album'];
    final String caption = _captionController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNootPreviewPage(
          track: track,
          songName: songName,
          artists: artists,
          albumImage: albumImage,
          caption: caption,
          createPost: _createPost,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.track;
    final String songName = track['name'] ?? '';
    final String artists = track['artists'] is List
        ? track['artists'].join(", ")
        : track['artists'].toString();
    final String? albumImage = track['album'];

    return Scaffold(
      appBar: AppBar(title: const Text('Create New Noot')),
      body: Column(
        children: [
          // MusicPlayerBar(title: 'Now Playing', playing: false),
          if (albumImage != null && albumImage.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Center(
                child: Image.network(albumImage,
                    fit: BoxFit.cover,
                    width: 500,
                    height: 400,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.music_note, size: 100)),
              ),
            )
          else
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              child: const Center(
                  child: Text('No Image', style: TextStyle(fontSize: 18))),
            ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: TextField(
              controller: _captionController,
              maxLines: 3,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Caption',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '$songName  •  $artists',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Spacer(),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                // Preview Button
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _showPreview,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8E08EF),
                        side: const BorderSide(
                          color: Color(0xFF8E08EF),
                          width: 2,
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 18
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Preview'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Share Button
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E08EF),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Share'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}