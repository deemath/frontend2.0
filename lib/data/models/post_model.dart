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
  int comments;
  List<String> likedBy;
  bool likedByMe;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.comments,
    required this.likedBy,
    required this.likedByMe,
    required this.createdAt,
    required this.updatedAt,
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
      comments: json['comments'] ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      likedByMe: false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
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
      'comments': comments,
      'likedBy': likedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
