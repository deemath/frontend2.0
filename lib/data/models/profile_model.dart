class ProfileModel {
  final String id;
  final String userId;
  final String username;
  final String userType;
  final String fullName;
  final String profileImage;
  final String bio;
  final int posts;
  final List<String> followers;
  final List<String> following;
  final List<String> albumImages;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userType,
    required this.fullName,
    required this.profileImage,
    required this.bio,
    required this.posts,
    required this.followers,
    required this.following,
    required this.albumImages,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    List<String> followersList;
    List<String> followingList;

    // Parse followers as List<String>
    if (json['followers'] is List) {
      followersList = (json['followers'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } else {
      followersList = [];
    }

    // Parse following as List<String>
    if (json['following'] is List) {
      followingList = (json['following'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } else {
      followingList = [];
    }

    return ProfileModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      userType: json['userType'] ?? 'public',
      fullName: json['fullName'] ?? '',
      profileImage: json['profileImage'] ?? '',
      bio: json['bio'] ?? '',
      posts: json['posts'] ?? 0,
      followers: followersList,
      following: followingList,
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
      'userType': userType,
      'fullName': fullName,
      'profileImage': profileImage,
      'bio': bio,
      'posts': posts,
      'followers': followers,
      'following': following,
      'albumImages': albumImages,
    };
  }
}

class EditProfileModel {
  final String username;
  final String email;
  final String fullName;
  final String profileImage;
  final String bio;
  final String userType; // Add userType to the edit profile model

  EditProfileModel({
    required this.username,
    required this.email,
    required this.fullName,
    required this.profileImage,
    required this.bio,
    this.userType = 'public', // Default to public
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'profileImage': profileImage,
      'bio': bio,
      'userType': userType,
    };
  }
}
