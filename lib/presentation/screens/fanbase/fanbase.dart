import 'package:flutter/material.dart';
import '/presentation/widgets/common/musicplayer_bar.dart';
import '/presentation/widgets/common/bottom_bar.dart';
import '/presentation/widgets/fanbases/fanbase_card.dart';

class FanbasePage extends StatefulWidget {
  const FanbasePage({super.key});

  @override
  State<FanbasePage> createState() => _FanbasePageState();
}

class _FanbasePageState extends State<FanbasePage> {
  List<Map<String, dynamic>> fanbases = [
    {
      'id': '1',
      'profileImageUrl': 'assets/images/spotify.png',
      'fanbaseName': 'Owlsykins',
      'topic':
          'Computer Science is the worst major, I can’t believe I did this to myself...',
      'numLikes': 120,
      'numPosts': 45,
      'numShares': 30,
      'isJoined': false,
    },
    {
      'id': '2',
      'profileImageUrl': 'assets/images/spotify.png',
      'fanbaseName': 'Desynkd',
      'topic':
          'I’m a computer science professor at UC Berkeley. Tech jobs are drying up and...',
      'numLikes': 200,
      'numPosts': 75,
      'numShares': 50,
      'isJoined': false,
    },
    {
      'id': '3',
      'profileImageUrl': 'assets/images/spotify.png',
      'fanbaseName': 'Cloudhopper',
      'topic':
          'The computer science graduate coming out of top schools like Berkeley with 4.0 GPA still...',
      'numLikes': 150,
      'numPosts': 60,
      'numShares': 40,
      'isJoined': false,
    },
  ];

  void toggleJoin(int index) {
    setState(() {
      fanbases[index]['isJoined'] = !(fanbases[index]['isJoined'] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fanbases'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: fanbases.length,
              itemBuilder: (context, index) {
                final fanbase = fanbases[index];
                return FanbaseCard(
                  fanbaseId: fanbase['id'],
                  profileImageUrl: fanbase['profileImageUrl'],
                  fanbaseName: fanbase['fanbaseName'],
                  topic: fanbase['topic'],
                  numLikes: fanbase['numLikes'],
                  numPosts: fanbase['numPosts'],
                  numShares: fanbase['numShares'],
                  isJoined: fanbase['isJoined'],
                  onJoin: () => toggleJoin(index),
                );
              },
            ),
          ),
          // MusicPlayerBar(title: 'Bluestar', playing: false),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
