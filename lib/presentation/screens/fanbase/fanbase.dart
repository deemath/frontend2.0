import 'package:flutter/material.dart';
import '/presentation/widgets/common/musicplayer_bar.dart';
import '/presentation/widgets/common/bottom_bar.dart';
import '/presentation/widgets/fanbases/fanbase_card.dart';

class FanbasePage extends StatelessWidget {
  final List<Map<String, dynamic>> fanbases = [
    {
      'profileImageUrl': 'assets/images/spotify.png',
      'fanbaseName': 'Owlsykins',
      'topic': 'Computer Science is the worst major, I can’t believe I did this to myself...',
    },
    {
      'profileImageUrl': 'assets/images/spotify.png',
      'fanbaseName': 'Desynkd',
      'topic': 'I’m a computer science professor at UC Berkeley. Tech jobs are drying up and...',
    },
    {
      'profileImageUrl': 'assets/images/spotify.png',
      'fanbaseName': 'Cloudhopper',
      'topic': 'The computer science graduate coming out of top schools like Berkeley with 4.0 GPA still...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fanbases'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: fanbases.length,
              itemBuilder: (context, index) {
                return FanbaseCard(
                  profileImageUrl: fanbases[index]['profileImageUrl'],
                  fanbaseName: fanbases[index]['fanbaseName'],
                  topic: fanbases[index]['topic'],
                  onJoin: () {},
                );
              },
            ),
          ),
          // Comment out or define MusicPlayerBar and BottomBar if needed
          MusicPlayerBar(title: 'Bluestar', playing: false),
          // BottomBar(),
        ],
      ),
      bottomNavigationBar: BottomBar(), // Uncomment and define if needed
    );
  }
}

// import 'package:flutter/material.dart';
// import '/presentation/widgets/fanbases/fanbase_background.dart';
// import '/presentation/widgets/fanbases/fanbase_card.dart';

// class FanbaseScreen extends StatelessWidget {
//   const FanbaseScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: 1,
//           child: Stack(
//             children: [
//               CustomPaint(
//                 painter: FanbaseBackground(),
//                 child: SizedBox.expand(),
//               ),
//               const FanbaseCardWidget(
//                 profileImageUrl: 'assets/images/user.png',
//                 fanbaseName: 'Music Lovers',
//                 topic: 'Let\'s discuss the latest trends in music and share our favorite tracks!',
//                 onJoin: null, // Replace with real callback
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
