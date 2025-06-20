import 'package:flutter/material.dart';

class PostProfileDetails extends StatelessWidget {
  const PostProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;

    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/images/hehe.png'),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                'ishaanKhatter',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'august - Taylor Swift',
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
