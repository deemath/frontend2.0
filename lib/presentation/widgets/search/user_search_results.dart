
import 'package:flutter/material.dart';

class UserSearchResults extends StatelessWidget {
  final List<dynamic> users;
  final String? query;

  const UserSearchResults({
    Key? key,
    required this.users,
    this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            query == null || query!.isEmpty
                ? 'Start typing to search for users...'
                : 'No users found for "\$query"',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            // You can use a placeholder or a network image if available
            backgroundImage: AssetImage('assets/images/profile_picture.jpg'),
          ),
          title: Text(user['name'] ?? 'No name'),
          subtitle: Text('@${user['name']?.toLowerCase().replaceAll(' ', '') ?? 'username'}'),
          trailing: ElevatedButton(
            onPressed: () {
              // Handle follow action
            },
            child: const Text('Follow'),
          ),
        );
      },
    );
  }
}
