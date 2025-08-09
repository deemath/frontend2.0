import 'package:flutter/material.dart';

class ProfileNameRow extends StatelessWidget {
  final String profileImageUrl;
  final String fanbaseName;

  const ProfileNameRow({
    required this.profileImageUrl,
    required this.fanbaseName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(profileImageUrl),
          radius: 14.0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          onBackgroundImageError: (exception, stackTrace) {
            // Handle image loading error silently
          },
        ),
        SizedBox(width: 12.0),
        Text(
          fanbaseName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// class ProfileNameRow extends StatelessWidget {
//   final String profileImageUrl;
//   final String fanbaseName;

//   const ProfileNameRow({
//     Key? key,
//     required this.profileImageUrl,
//     required this.fanbaseName,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         CircleAvatar(
//           backgroundImage: AssetImage(profileImageUrl),
//           radius: 16.0,
//         ),
//         const SizedBox(width: 12.0),
//         Text(
//           fanbaseName,
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.onPrimary,
//             fontWeight: FontWeight.bold,
//             fontSize: 16.0,
//           ),
//         ),
//       ],
//     );
//   }
// }
