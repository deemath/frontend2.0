import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/searchbar.dart';

class SearchFeedScreen extends StatefulWidget {
  const SearchFeedScreen({Key? key}) : super(key: key);

  @override
  State<SearchFeedScreen> createState() => _SearchFeedScreenState();
}

class _SearchFeedScreenState extends State<SearchFeedScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InstagramSearchBar(
          controller: _searchController,
          onChanged: (query) {
            // Handle search logic here
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: const Center(child: Text('Search results here')),
    );
  }
}