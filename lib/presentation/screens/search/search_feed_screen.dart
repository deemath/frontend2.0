import 'package:flutter/material.dart';
import 'package:frontend/data/services/search_service.dart';
import 'package:frontend/presentation/widgets/search/allsearch_results.dart';
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

  // Add this to your state
  final SearchService _searchService = SearchService();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  // Mock search results
  final Map<String, List<Map<String, String>>> _mockResults = {
    'People': [
      {'name': 'John Doe', 'subtitle': 'Friend'},
      {'name': 'Jane Smith', 'subtitle': 'Musician'},
    ],
    'Pages': [
      {'name': 'Flutter Devs', 'subtitle': 'Community Page'},
      {'name': 'Music Lovers', 'subtitle': 'Interest Page'},
    ],
    'Groups': [
      {'name': 'Open Source Group', 'subtitle': 'Public Group'},
      {'name': 'Dart Enthusiasts', 'subtitle': 'Private Group'},
    ],
  };

  List<Map<String, String>> get _allResults {
    return _mockResults.values.expand((list) => list).toList();
  }

  void _onSearchSubmitted(String query) async {
    setState(() {
      _query = query;
      _hasSearched = query.trim().isNotEmpty;
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
      // _hasSearched is NOT set here, so results don't show while typing
    });
  }

  Widget _buildSection(String title, List<Map<String, String>> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ...items.map((item) => ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/hehe.png'),
              ),
              title: Text(item['name'] ?? ''),
              subtitle: Text(item['subtitle'] ?? ''),
              onTap: () {},
            )),
        const Divider(),
      ],
    );
  }

  // Temporary mock images for explore feed (add your own asset images)
  final List<String> _exploreImages = [
    'assets/images/hehe.png',
    'assets/images/hehe.png',
    'assets/images/hehe.png',
    // Add more asset image paths here
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
          // Only show CategorySelector if not showing results
          if (!showResults)
            CategorySelector(
              categories: _categories,
              selectedIndex: _selectedCategory,
              onCategorySelected: (index) {
                setState(() {
                  _selectedCategory = index;
                  // Optionally filter explore feed or results here
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
                        child: ListView(
                          children: [
                            if (_selectedSegment == 0)
                              AllSearchResults(
                                results: _searchResults, // <-- USE THIS
                                query: _query,
                              ),
                            if (_selectedSegment == 1)
                              _buildSection(
                                  'People', _mockResults['People'] ?? []),
                            if (_selectedSegment == 2)
                              _buildSection(
                                  'Pages', _mockResults['Pages'] ?? []),
                            if (_selectedSegment == 3)
                              _buildSection(
                                  'Groups', _mockResults['Groups'] ?? []),
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
