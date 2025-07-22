import 'package:flutter/material.dart';
import '../../widgets/song_post/post.dart';
import '../../widgets/song_post/post_shape.dart';

class CreateNootPreviewPage extends StatefulWidget {
  final Map<String, dynamic> track;
  final String songName;
  final String artists;
  final String? albumImage;
  final String caption;
  final Future<void> Function() createPost;

  const CreateNootPreviewPage({
    Key? key,
    required this.track,
    required this.songName,
    required this.artists,
    required this.albumImage,
    required this.caption,
    required this.createPost,
  }) : super(key: key);

  @override
  State<CreateNootPreviewPage> createState() => _CreateNootPreviewPageState();
}

class _CreateNootPreviewPageState extends State<CreateNootPreviewPage> {
  bool _isLoading = false;

  Future<void> _handleShare() async {
    setState(() { _isLoading = true; });
    await widget.createPost();
    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview Noot'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6, 
                ),
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    // Background shape with reduced height
                    CustomPaint(
                      painter: PostShape(
                        backgroundColor: const Color(0xFFF5F5F5),
                      ),
                      child: Container(),
                    ),
                    // Modern content layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double squareSize = constraints.maxWidth - 40.0; 
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Album art positioned much lower for modern look
                            Container(
                              height: squareSize,
                              margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 80.0, 
                                bottom: 16.0,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0), 
                                child: widget.albumImage != null && widget.albumImage!.isNotEmpty
                                    ? Image.network(
                                        widget.albumImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.music_note,
                                              size: 60,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.music_note,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                            ),
                            // Song details with modern typography
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.songName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700, 
                                      fontSize: 20, 
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.artists,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (widget.caption.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      widget.caption,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
                                      ),
                                      maxLines: 2, 
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 20), 
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Modern share button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleShare,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E08EF),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('Share'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}