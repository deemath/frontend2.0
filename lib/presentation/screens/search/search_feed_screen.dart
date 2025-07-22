import 'package:flutter/material.dart';
import 'package:frontend/data/services/search_service.dart';

import 'package:frontend/presentation/widgets/song_post/post.dart';
import 'package:frontend/presentation/widgets/search/explore_feed.dart';
import 'package:frontend/presentation/widgets/search/segmant_divider.dart';
import 'package:frontend/presentation/widgets/song_post/post_shape.dart';

import 'package:frontend/presentation/widgets/search/searchbar.dart';

import 'package:frontend/presentation/widgets/search/category_selector.dart';
import 'package:frontend/presentation/widgets/search/user_search_results.dart';

class SearchFeedScreen extends StatefulWidget {
  const SearchFeedScreen({Key? key}) : super(key: key);

  @override
  State<SearchFeedScreen> createState() => _SearchFeedScreenState();
}

class _SearchFeedScreenState extends State<SearchFeedScreen> {
  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
      _hasSearched = false;
    });
  }

  Future<void> _onSearchSubmitted(String value) async {
    setState(() {
      _query = value;
      _hasSearched = true;
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await _searchService.search(_query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Search failed. Please try again.';
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _hasSearched = false;
  int _selectedSegment = 0;

  final List<String> _segments = [
    'All',
    'People',
    'Pages',
    'Song Posts',
    'Posts',
    'Fanbases',
    'Playlists'
  ];

  final SearchService _searchService = SearchService();
  Map<String, dynamic> _searchResults = {};
  bool _isLoading = false;
  String? _error;

  List<String> _exploreImages = [];

  // Fetch song posts for explore feed (album images, ascending by date)
  Future<void> _fetchExploreImages() async {
    try {
      final results = await _searchService.search(''); // Empty query to get all
      final songPosts = (results['songPosts'] ?? []) as List;
      // If backend supports sorting, you should add sort there. Otherwise, sort here if date is available.
      setState(() {
        _exploreImages = songPosts
            .map<String>(
                (post) => post['albumImage'] ?? 'assets/images/song.png')
            .toList();
      });
    } catch (e) {
      // fallback to empty or default
      setState(() {
        _exploreImages = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExploreImages();
  }

  final List<String> _categories = [
    'Trending',
    'Pop',
    'Superhits',
    'Kollywood',
    'Raps',
    'Kpop'
  ];
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final showResults = _hasSearched && _query.isNotEmpty;

    Widget temporaryFanbaseCard() {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/hehe.png'),
          ),
          title: const Text('Temporary Fanbase'),
          subtitle: const Text(
              'This is a temporary fanbase card shown in search feed.'),
          onTap: () {
            // TODO: Add tap action if needed
          },
        ),
      );
    }

    Widget temporaryPostCard(int index) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/hehe.png'),
          ),
          title: Text('Temporary Post #\$index'),
          subtitle:
              const Text('This is a temporary post shown in search feed.'),
          onTap: () {
            // TODO: Add tap action if needed
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: InstagramSearchBar(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchSubmitted,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          if (showResults)
            SegmentDivider(
              segments: _segments,
              selectedIndex: _selectedSegment,
              onSegmentSelected: (index) {
                setState(() {
                  _selectedSegment = index;
                });
              },
            )
          else
            CategorySelector(
              categories: _categories,
              selectedIndex: _selectedCategory,
              onCategorySelected: (index) {
                setState(() {
                  _selectedCategory = index;
                });
              },
            ),
          Expanded(
            child: showResults
                ? (_isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _selectedSegment == 1 // People
                        ? Builder(
                            builder: (context) {
                              final users =
                                  (_searchResults['users'] ?? []) as List;
                              return UserSearchResults(
                                users: users,
                                query: _query,
                              );
                            },
                          )
                        : _selectedSegment == 3 // Song Posts
                            ? Builder(
                                builder: (context) {
                                  final songPosts =
                                      (_searchResults['songPosts'] ?? [])
                                          as List;
                                  if (songPosts.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Center(
                                        child: Text(
                                          _query.isEmpty
                                              ? 'Start typing to search Song Posts...'
                                              : 'There is no related posts',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600]),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  // Show song posts as a vertical list
                                  return ListView.separated(
                                    itemCount: songPosts.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 16),
                                    itemBuilder: (context, index) {
                                      final post = songPosts[index];
                                      final img = post['albumImage'] ??
                                          'assets/images/song.png';
                                      final isNetwork = img is String &&
                                          img.startsWith('http');
                                      final username =
                                          post['username'] ?? 'Unknown User';
                                      final songName =
                                          post['name'] ?? 'Unknown Song';
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.04),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Username
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  12, 12, 12, 4),
                                              child: Text(
                                                username,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            // Song name (minor opacity)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              child: Text(
                                                songName,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Album image
                                            AspectRatio(
                                              aspectRatio: 1,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: isNetwork
                                                    ? Image.network(
                                                        img,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) =>
                                                            const Icon(Icons.broken_image, size: 80),
                                                      )
                                                    : Image.asset(
                                                        img,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) =>
                                                            const Icon(Icons.broken_image, size: 80),
                                                      ),
                                              ),
                                            ),
                                            // Like, Comment, Share row
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.favorite_border, size: 26),
                                                    onPressed: () {},
                                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  IconButton(
                                                    icon: const Icon(Icons.mode_comment_outlined, size: 26),
                                                    onPressed: () {},
                                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  IconButton(
                                                    icon: const Icon(Icons.share_outlined, size: 26),
                                                    onPressed: () {},
                                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Optional: Caption
                                            if (post['caption'] != null && post['caption'].toString().isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                                child: Text(
                                                  post['caption'],
                                                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                                                ),
                                              ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            : _selectedSegment == 4 // Posts
                                ? Builder(
                                    builder: (context) {
                                      final posts =
                                          (_searchResults['posts'] ?? [])
                                              as List;
                                      if (posts.isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: Center(
                                            child: Text(
                                              _query.isEmpty
                                                  ? 'Start typing to search Posts...'
                                                  : 'There is no related posts',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600]),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }
                                      // Show posts as a vertical list
                                      return ListView.separated(
                                        itemCount: posts.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 16),
                                        itemBuilder: (context, index) {
                                          final post = posts[index];
                                          final username =
                                              post['username'] ?? 'Unknown User';
                                          final caption = post['caption'] ?? '';
                                          return Post(
                                            username: username,
                                            caption: caption,
                                            isLiked: false,
                                            isPlaying: false,
                                            isCurrentTrack: false,
                                            onLike: () {},
                                            onComment: () {},
                                            onShare: () {},
                                            onPlayPause: () {},
                                            onUsernameTap: () {},
                                          );
                                        },
                                      );
                                    },
                                  )
                            : ExploreFeed(imageUrls: _exploreImages))
                : ExploreFeed(imageUrls: _exploreImages),
          ),
        ],
      ),
    );
  }
}
// Duplicate block removed. File ends cleanly after the main Scaffold.
