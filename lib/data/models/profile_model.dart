class ProfileModel {
  final String id;
  final String userId;
  final String username;
  final String profileImage;
  final String bio;
  final int posts;
  final int followers;
  final int following;
  final List<String> albumImages;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.profileImage,
    required this.bio,
    required this.posts,
    required this.followers,
    required this.following,
    required this.albumImages,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    int followersCount;
    int followingCount;

    // Handle followers as int or List
    if (json['followers'] is int) {
      followersCount = json['followers'];
    } else if (json['followers'] is List) {
      followersCount = (json['followers'] as List).length;
    } else {
      followersCount = 0;
    }

    if (json['following'] is int) {
      followingCount = json['following'];
    } else if (json['following'] is List) {
      followingCount = (json['following'] as List).length;
    } else {
      followingCount = 0;
    }

    return ProfileModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      profileImage: json['profileImage'] ?? '',
      bio: json['bio'] ?? '',
      posts: json['posts'] ?? 0,
      followers: followersCount,
      following: followingCount,
      albumImages: (json['albumImages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'username': username,
      'profileImage': profileImage,
      'bio': bio,
      'posts': posts,
      'followers': followers,
      'following': following,
      'albumImages': albumImages,
    };
  }
}
