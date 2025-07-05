import 'package:flutter/material.dart';

// ================= SongControlWidget =================
class SongControlWidget extends StatelessWidget {
  const SongControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 131,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: const Center(
          child: Text(
            'Song Control',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= TrackDetailWidget =================
class TrackDetailWidget extends StatelessWidget {
  const TrackDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 359,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: const Center(
          child: Text(
            'Track Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= UserDetailWidget =================
class UserDetailWidget extends StatelessWidget {
  final Map<String, dynamic>? details;

  const UserDetailWidget({super.key, this.details});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;
    // demo data
    final data = details ?? {
      'username': 'ishaanKhatter',
      'song': 'august - Taylor Swift',
      'avatar': 'assets/images/hehe.png',
    };

    return Expanded(
      flex: 359,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Large Profile Picture
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(data['avatar']),
            ),
            const SizedBox(width: 18),
            // Username only, vertically centered
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data['username'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= InteractionWidget =================
class InteractionWidget extends StatelessWidget {
  const InteractionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 131,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black.withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            'Interactions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= PostArtWidget =================
class PostArtWidget extends StatelessWidget {
  const PostArtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate square size: width minus left and right margins
        double squareSize =
            constraints.maxWidth - 18.0; // 9.0 left + 9.0 right margins
        return Container(
          height: squareSize, // Height equals width to make it square
          margin: const EdgeInsets.only(
            left: 9.0,
            right: 9.0,
            top: 9.0,
            bottom: 9.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/song.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      },
    );
  }
}

// ================= FooterWidget =================
class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 73,
      child: Row(
        children: [
          TrackDetailWidget(),
          InteractionWidget(),
        ],
      ),
    );
  }
}

// ================= HeaderWidget =================
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 72,
      child: Row(
        children: [
          UserDetailWidget(),
          SongControlWidget(),
        ],
      ),
    );
  }
}

// ================= DemoContentWidget =================
class DemoContentWidget extends StatelessWidget {
  const DemoContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Column(
        children: [
          // Row 1: 2 columns
          HeaderWidget(),
          // Gap between Row 1 and Row 2
          // const SizedBox(height: 5.0),
          // Row 2: 1 column (full width) - Square shape
          PostArtWidget(),
          // Gap between Row 2 and Row 3
          // const SizedBox(height: 5.0),
          // Row 3: 2 columns
          FooterWidget(),
        ],
      ),
    );
  }
} 