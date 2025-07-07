import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isAuthenticated = false;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  void setUser(Map<String, dynamic> userData) {
    _user = User.fromJson(userData);
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    _isAuthenticated = true;
    notifyListeners();
  }

  void login(Map<String, dynamic> userData, String token) {
    setUser(userData);
    setToken(token);
  }

  void logout() {
    _user = null;
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
