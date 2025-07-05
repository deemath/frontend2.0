import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MusicPlayerControls extends StatelessWidget {
  final bool playing;
  final VoidCallback? onPrevious;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;

  const MusicPlayerControls({
    Key? key,
    required this.playing,
    this.onPrevious,
    this.onPlayPause,
    this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(LucideIcons.skipBack, color: Theme.of(context).colorScheme.onPrimary, size: 20),
          onPressed: onPrevious,
        ),
        IconButton(
          icon: Icon(playing ? LucideIcons.pause : LucideIcons.play, color: Theme.of(context).colorScheme.onPrimary, size: 20),
          onPressed: onPlayPause,
        ),
        IconButton(
          icon: Icon(LucideIcons.skipForward, color: Theme.of(context).colorScheme.onPrimary, size: 20),
          onPressed: onNext,
        ),
      ],
    );
  }
}

class MusicPlayerBar extends StatelessWidget {
  final String title;
  final bool playing;

  MusicPlayerBar({required this.title, this.playing = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 5.0,
            offset: Offset(0, -1),
          ),
        ],
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: TextStyle(color: Colors.purple, fontSize: 13)),
              SizedBox(width: 4.0),
              Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 13)),
            ],
          ),
          MusicPlayerControls(
            playing: playing,
            onPrevious: () {},
            onPlayPause: () {},
            onNext: () {},
          ),
        ]  
      ),
    );
  }
}
