import 'package:flutter/material.dart';
import './fanbase_profilebar.dart';
// import './demo/demo.dart';

class FanbaseCard extends StatelessWidget {
  final String profileImageUrl;
  final String fanbaseName;
  final String topic;
  final VoidCallback onJoin;

  FanbaseCard({
    required this.profileImageUrl,
    required this.fanbaseName,
    required this.topic,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // DemoScreen(),
              ProfileNameRow(
                profileImageUrl: profileImageUrl,
                fanbaseName: fanbaseName,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  child: const Text('Join'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      bottomLeft: Radius.circular(18.0),
                      bottomRight: Radius.circular(18.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    topic,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import './fanbase_profilebar.dart';

// class FanbaseCardWidget extends StatelessWidget {
//   final String profileImageUrl;
//   final String fanbaseName;
//   final String topic;
//   final VoidCallback? onJoin;

//   const FanbaseCardWidget({
//     super.key,
//     required this.profileImageUrl,
//     required this.fanbaseName,
//     required this.topic,
//     required this.onJoin,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ProfileNameRow(
//                   profileImageUrl: profileImageUrl,
//                   fanbaseName: fanbaseName,
//                 ),
//                 ElevatedButton(
//                   onPressed: onJoin,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 8.0,
//                     ),
//                   ),
//                   child: const Text('Join'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(12.0),
//               padding: const EdgeInsets.all(16.0),
//               // decoration: BoxDecoration(
//               //   color: Colors.white,
//               //   borderRadius: BorderRadius.circular(12.0),
//               // ),
//               child: Text(
//                 topic,
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.primary,
//                   fontSize: 14.0,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

