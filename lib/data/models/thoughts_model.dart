class ThoughtsPost {
  final String id;
  final String userId;
  final String? username;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  int likes;
  List<String> likedBy;
  List<ThoughtsComment> comments;
  String? songName;
  String? artistName;

  ThoughtsPost({
    required this.id,
    required this.userId,
    this.username,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.likedBy,
    required this.comments,
    this.songName,
    this.artistName,
  });

  factory ThoughtsPost.fromJson(Map<String, dynamic> json) {
  return ThoughtsPost(
    id: json['_id'] ?? '',
    userId: json['userId'] ?? '',
    username: json['username'],
    text: json['text'] ?? json['thoughtsText'] ?? '',
    createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    likes: json['likes'] ?? 0,
    likedBy: List<String>.from(json['likedBy'] ?? []),
    comments: (json['comments'] as List<dynamic>?)
        ?.map((c) => ThoughtsComment.fromJson(c))
        .toList() ?? [],
    songName: json['songName'],
    artistName: json['artistName'],
  );
}

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'username': username,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likes': likes,
      'likedBy': likedBy,
      'comments': comments.map((c) => c.toJson()).toList(),
      'songName': songName,
      'artistName': artistName,
    };
  }
}

class ThoughtsComment {
  final String id;
  final String userId;
  final String? username;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  int likes;
  List<String> likedBy;

  ThoughtsComment({
    required this.id,
    required this.userId,
    this.username,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.likedBy,
  });

  factory ThoughtsComment.fromJson(Map<String, dynamic> json) {
    return ThoughtsComment(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'],
      text: json['thoughtsText'] ?? json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      likes: json['likes'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likes': likes,
      'likedBy': likedBy,
    };
  }
}
