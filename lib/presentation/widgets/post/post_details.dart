import 'package:flutter/material.dart';

class PostProfileDetails extends StatelessWidget {
  final Map<String, dynamic>? details;

  const PostProfileDetails({super.key, this.details});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;
    // Use provided details or fallback to demo data
    final data = details ?? {
      'username': 'ishaanKhatter',
      'song': 'august - Taylor Swift',
      'avatar': 'assets/images/hehe.png',
    };

    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(data['avatar']),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['username'],
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                data['song'],
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
