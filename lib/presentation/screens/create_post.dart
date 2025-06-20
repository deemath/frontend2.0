import 'package:flutter/material.dart';
import '/data/services/spotify_service.dart';

class CreatePostPage extends StatefulWidget {
  final SpotifyService spotifyService;

  const CreatePostPage({
    Key? key,
    required this.spotifyService,
  }) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _searchResults;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await widget.spotifyService.searchTracks(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: colorScheme.onPrimary),
              decoration: InputDecoration(
                hintText: 'Search for a song or artist...',
                hintStyle: TextStyle(color: colorScheme.onPrimary.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: colorScheme.onPrimary.withOpacity(0.5)),
                suffixIcon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary.withOpacity(0.5)),
                        ),
                      )
                    : IconButton(
                        icon: Icon(Icons.clear, color: colorScheme.onPrimary.withOpacity(0.5)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = null;
                          });
                        },
                      ),
                filled: true,
                fillColor: theme.cardColor.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.onPrimary.withOpacity(0.4)),
                ),
              ),
              onSubmitted: _performSearch,
            ),
            if (_searchResults != null) ...[
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults!['tracks']['items'].length,
                  itemBuilder: (context, index) {
                    final track = _searchResults!['tracks']['items'][index];
                    return ListTile(
                      leading: track['album']['images'].isNotEmpty
                          ? Image.network(
                              track['album']['images'][0]['url'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(width: 50, height: 50),
                      title: Text(
                        track['name'],
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                      subtitle: Text(
                        track['artists'].map((artist) => artist['name']).join(', '),
                        style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.6)),
                      ),
                      onTap: () {
                        // TODO: Handle track selection
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
