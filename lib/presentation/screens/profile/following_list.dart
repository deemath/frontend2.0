import 'package:flutter/material.dart';
import './user_profiles.dart'; // Import the UserProfilePage

// following: List<Map<String, dynamic>> with userId, username, profileImage
class FollowingListPage extends StatelessWidget {
  final List<dynamic> following;

  const FollowingListPage({Key? key, required this.following})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: following.isEmpty
          ? const Center(
              child: Text(
                'Not following anyone yet.',
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              itemCount: following.length,
              itemBuilder: (context, index) {
                final user = following[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (user['profileImage'] != null &&
                            user['profileImage'].toString().isNotEmpty)
                        ? NetworkImage(user['profileImage'])
                        : null,
                    backgroundColor: Colors.grey,
                  ),
                  title: Text(
                    user['username'] ?? 'Unknown',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: (user['fullName'] != null &&
                          user['fullName'].toString().isNotEmpty)
                      ? Text(
                          user['fullName'],
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12),
                        )
                      : null,
                  onTap: () {
                    if (user['userId'] != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            userId: user['userId'],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
