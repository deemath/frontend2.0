class EditProfileModel {
  final String name;
  final String username;
  final String bio;
  final String profileImage;

  EditProfileModel({
    required this.name,
    required this.username,
    required this.bio,
    required this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'bio': bio,
      'profileImage': profileImage,
    };
  }
}
