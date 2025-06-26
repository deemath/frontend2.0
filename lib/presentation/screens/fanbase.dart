import 'package:flutter/material.dart';
import '../widgets/playing_bar.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/fanbases/fanbase_card.dart';

class FanbasePage extends StatefulWidget {
  const FanbasePage({super.key});

  @override
  State<FanbasePage> createState() => _FanbasePageState();
}

class _FanbasePageState extends State<FanbasePage> {
  late List<Map<String, dynamic>> fanbases;

  @override
  void initState() {
    super.initState();
    _loadFanbases();
  }

  void _loadFanbases() {
    fanbases = [
      {
        'title': '128 Democrats cross the aisle and help Republicans block...',
        'subtitle': 'AOC-backed bid to impeach Trump over Iran strikes',
        'url': 'https://www.independent.co.uk/news/world/americas/us-politics/trump-impeachment-iran',
        'votes': 24000,
        'comments': 2200,
        'award': 1,
        'image': ['https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'],
      },
      {
        'title': 'Taylor Swift announces new album during concert',
        'subtitle': 'Midnights to be released next month',
        'url': 'https://example.com/taylor-swift',
        'votes': 19000,
        'comments': 3500,
        'award': 3,
        'image': [],
      },
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Fanbases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFanbases,
            tooltip: 'Reload fanbases',
          )
        ],
      ),
      body: Column(
        children: [
          PlayingBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: fanbases.length,
              itemBuilder: (context, index) {
                return FanbaseCard(post: fanbases[index]);
              },
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
