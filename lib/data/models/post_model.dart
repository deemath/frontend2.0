import 'package:frontend/data/models/post_model.dart';  

class Comment {
  final String id;
  final String userId;
  final String username;
  final String text;
  final DateTime createdAt;
  int likes;
  List<String> likedBy;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
    required this.likes,
    required this.likedBy,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['_id'],
    userId: json['userId'],
    username: json['username'],
    text: json['text'],
    createdAt: DateTime.parse(json['createdAt']),
    likes: json['likes'] ?? 0,
    likedBy: List<String>.from(json['likedBy'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': userId,
    'username': username,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
    'likes': likes,
    'likedBy': likedBy,
  };
}

class Post {
  final String id;
  final String trackId;
  final String songName;
  final String artists;
  final String? albumImage;
  final String? caption;
  final String userId;
  final String username;
  int likes;
  int commentsCount;
  List<String> likedBy;
  bool likedByMe;
  final DateTime createdAt;
  final DateTime updatedAt;
  List<Comment> comments;

  Post({
    required this.id,
    required this.trackId,
    required this.songName,
    required this.artists,
    this.albumImage,
    this.caption,
    required this.userId,
    required this.username,
    required this.likes,
    required this.commentsCount,
    required this.likedBy,
    required this.likedByMe,
    required this.createdAt,
    required this.updatedAt,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      trackId: json['trackId'] ?? '',
      songName: json['songName'] ?? '',
      artists: json['artists'] ?? '',
      albumImage: json['albumImage'],
      caption: json['caption'],
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      likes: json['likes'] ?? 0,
      commentsCount: json['comments'] is int ? json['comments'] : (json['comments'] as List).length,
      likedBy: (json['likedBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      likedByMe: false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      comments: (json['comments'] is List)
        ? (json['comments'] as List)
            .map((c) => Comment.fromJson(c as Map<String, dynamic>))
            .toList()
        : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'trackId': trackId,
      'songName': songName,
      'artists': artists,
      'albumImage': albumImage,
      'caption': caption,
      'userId': userId,
      'username': username,
      'likes': likes,
      'comments': comments.map((c) => c.toJson()).toList(),
      'commentsCount': commentsCount,
      'likedBy': likedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
