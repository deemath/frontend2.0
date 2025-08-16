import 'package:flutter/material.dart';

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
