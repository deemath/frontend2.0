import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/search/allsearch_results.dart';
import 'package:frontend/presentation/widgets/searchbar.dart';

class SearchFeedScreen extends StatefulWidget {
  const SearchFeedScreen({Key? key}) : super(key: key);

  @override
  State<SearchFeedScreen> createState() => _SearchFeedScreenState();
}

class _SearchFeedScreenState extends State<SearchFeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _hasSearched = false;

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

  void _onSearch(String query) {
    setState(() {
      _query = query;
      _hasSearched = query.trim().isNotEmpty;
    });
  }

  Widget _buildSection(String title, List<Map<String, String>> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        ...items.map((item) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(item['name'] ?? ''),
              subtitle: Text(item['subtitle'] ?? ''),
              onTap: () {},
            )),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showResults = _hasSearched && _query.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: InstagramSearchBar(
          controller: _searchController,
          onChanged: _onSearch,
        ),
        automaticallyImplyLeading: false,
      ),
      body: showResults
          ? ListView(
              children: [
                AllSearchResults(
                  results: _allResults,
                  query: _query,
                ),
                _buildSection('People', _mockResults['People'] ?? []),
                _buildSection('Pages', _mockResults['Pages'] ?? []),
                _buildSection('Groups', _mockResults['Groups'] ?? []),
              ],
            )
          : const Center(child: Text('Search results here')),
    );
  }
}
