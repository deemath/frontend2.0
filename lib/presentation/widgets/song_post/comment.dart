import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/data/models/post_model.dart';
import 'package:frontend/data/services/song_post_service.dart';

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  return DateFormat('dd MMM').format(dateTime);
}

class CommentSection extends StatefulWidget {
  final List<Comment> comments;
  final Function(String) onAddComment;
  final String postId;
  final String currentUserId;
  final SongPostService songPostService;
  const CommentSection({Key? key, required this.comments, required this.onAddComment, required this.postId, required this.currentUserId, required this.songPostService}) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              final comment = widget.comments[index];
              return ListTile(
                leading: CircleAvatar(child: Text(comment.username[0])),
                title: Text(
                  comment.username,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  comment.text,
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(timeAgo(comment.createdAt)),
                    IconButton(
                      icon: Icon(
                        comment.likedBy.contains(widget.currentUserId) ? Icons.favorite : Icons.favorite_border,
                        color: comment.likedBy.contains(widget.currentUserId) ? Colors.purple : Colors.grey,
                        size: 20,
                      ),
                      onPressed: () async {
                        final result = await widget.songPostService.likeComment(widget.postId, comment.id, widget.currentUserId);
                        if (result['success']) {
                          setState(() {
                            widget.comments[index] = Comment.fromJson(
                              (result['data']['comments'] as List).firstWhere((c) => c['_id'] == comment.id),
                            );
                          });
                        }
                      },
                    ),
                    Text('${comment.likes}', style: TextStyle(color: Colors.black)),
                  ],
                ),
              );
            },
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.purple),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    widget.onAddComment(_controller.text.trim());
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
