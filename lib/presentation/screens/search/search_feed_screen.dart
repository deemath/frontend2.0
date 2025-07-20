import 'package:flutter/material.dart';
import 'package:frontend/data/services/search_service.dart';
import 'package:frontend/presentation/widgets/search/allsearch_results.dart';
import 'package:frontend/presentation/widgets/song_post/post.dart';
import 'package:frontend/presentation/widgets/search/explore_feed.dart';
import 'package:frontend/presentation/widgets/search/segmant_divider.dart';

import 'package:frontend/presentation/widgets/search/searchbar.dart';

import 'package:frontend/presentation/widgets/search/category_selector.dart';

class SearchFeedScreen extends StatefulWidget {
  const SearchFeedScreen({Key? key}) : super(key: key);

  @override
  State<SearchFeedScreen> createState() => _SearchFeedScreenState();
}

class _SearchFeedScreenState extends State<SearchFeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _hasSearched = false;
  int _selectedSegment = 0;

  final List<String> _segments = [
    'All',
    'People',
    'Pages',
    'Groups',
    'Posts',
    'Fanbases',
    'Playlists'
  ];

  final SearchService _searchService = SearchService();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  void _onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _hasSearched = false;
        _query = '';
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _query = query;
      _hasSearched = true;
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _searchService.search(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _query = query;
      if (query.trim().isEmpty && _hasSearched) {
        _hasSearched = false;
        _searchResults.clear();
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredResults() {
    if (_selectedSegment == 0) {
      return _searchResults;
    }

    final selectedCategory = _segments[_selectedSegment].toLowerCase();
    
    return _searchResults.where((result) {
      final category = result['category']?.toLowerCase();
      switch (selectedCategory) {
        case 'people':
          return category == 'users';
        case 'fanbases':
          return category == 'fanbases';
        case 'posts':
          return category == 'songposts' || category == 'posts';
        case 'pages':
          return category == 'profiles';
        default:
          return category == selectedCategory;
      }
    }).toList();
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    if (_searchResults.isEmpty && _hasSearched) {
      return const Center(child: Text('No results found.'));
    }

    final filteredResults = _getFilteredResults();

    if (filteredResults.isEmpty && _hasSearched) {
      return Center(
          child: Text('No results for "${_segments[_selectedSegment]}".'));
    }

    return AllSearchResults(
      results: filteredResults,
      query: _query,
    );
  }

  final List<String> _exploreImages = [
    'assets/images/hehe.png',
    'assets/images/hehe.png',
    'assets/images/hehe.png',
  ];

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
          subtitle: const Text('This is a temporary fanbase card shown in search feed.'),
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
          subtitle: const Text('This is a temporary post shown in search feed.'),
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
                ? Column(
                    children: [
                      SegmentDivider(
                        segments: _segments,
                        selectedIndex: _selectedSegment,
                        onSegmentSelected: (index) {
                          setState(() {
                            _selectedSegment = index;
                          });
                        },
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _error != null
                                ? Center(child: Text('Error: $_error'))
                                : ListView(
                                    children: [
                                      if (_selectedSegment == 0) ...[
                                        temporaryFanbaseCard(),
                                        temporaryPostCard(1),
                                        temporaryPostCard(2),
                                        temporaryPostCard(3),
                                        temporaryPostCard(4),
                                        temporaryPostCard(5),
                                        // Temporary song post cards below the 6 cards
                                        Post(
                                          username: 'User1',
                                          songName: 'Song One',
                                          artists: 'Artist A',
                                          albumImage: 'assets/images/song.png',
                                        ),
                                        Post(
                                          username: 'User2',
                                          songName: 'Song Two',
                                          artists: 'Artist B',
                                          albumImage: 'assets/images/song.png',
                                        ),
                                        Post(
                                          username: 'User3',
                                          songName: 'Song Three',
                                          artists: 'Artist C',
                                          albumImage: 'assets/images/song.png',
                                        ),
                                        Post(
                                          username: 'User4',
                                          songName: 'Song Four',
                                          artists: 'Artist D',
                                          albumImage: 'assets/images/song.png',
                                        ),
                                        Post(
                                          username: 'User5',
                                          songName: 'Song Five',
                                          artists: 'Artist E',
                                          albumImage: 'assets/images/song.png',
                                        ),
                                        Post(
                                          username: 'User6',
                                          songName: 'Song Six',
                                          artists: 'Artist F',
                                          albumImage: 'assets/images/song.png',
                                        ),
                                      ],
                                      if (_selectedSegment == 1)
                                        _buildSection(
                                            'People',
                                            _searchResults['users'] ?? [],
                                            'name',
                                            'email'),
                                      if (_selectedSegment == 2)
                                        _buildSection(
                                            'Fanbases',
                                            _searchResults['fanbases'] ?? [],
                                            'name',
                                            'description'),
                                      if (_selectedSegment == 3)
                                        _buildSection(
                                            'Song Posts',
                                            _searchResults['songPosts'] ?? [],
                                            'name',
                                            'artists'),
                                      if (_selectedSegment == 4)
                                        _buildSection(
                                            'Posts',
                                            _searchResults['posts'] ?? [],
                                            'songTitle',
                                            'artistName'),
                                      if (_selectedSegment == 5)
                                        _buildSection(
                                            'Profiles',
                                            _searchResults['profiles'] ?? [],
                                            'username',
                                            'bio'),
                                    ],
                                  ),
                      ),
                    ],
                  )
                : ExploreFeed(imageUrls: _exploreImages),
          ),
        ],
      ),
    );
  }
}
