import 'package:flutter/material.dart';
import '../../widgets/playing_bar.dart';

class CreateNewNootPage extends StatefulWidget {
  final Map<String, dynamic> track;

  const CreateNewNootPage({Key? key, required this.track}) : super(key: key);

  @override
  State<CreateNewNootPage> createState() => _CreateNewNootPageState();
}

class _CreateNewNootPageState extends State<CreateNewNootPage> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.track;
    final String songName = track['name'] ?? '';
    final String artists = track['artists'] is List ? track['artists'].join(", ") : track['artists'].toString();
    final String? albumImage = track['album'];

    return Scaffold(
      appBar: AppBar(title: const Text('Create New Noot')),
      body: Column(

        children: [
          const PlayingBar(),
          if (albumImage != null && albumImage.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Center(
                child: Image.network(albumImage, fit: BoxFit.cover, width: 500, height: 400, errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note, size: 100)),
              ),
            )
          else
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              child: const Center(child: Text('No Image', style: TextStyle(fontSize: 18))),
            ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: TextField(
              controller: _captionController,
              maxLines: 3,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Caption',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '$songName  •  $artists',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E08EF),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Share'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
