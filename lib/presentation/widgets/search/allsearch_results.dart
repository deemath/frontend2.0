import 'package:flutter/material.dart';

class AllSearchResults extends StatelessWidget {
  final List<Map<String, String>> results;
  final String? query;

  const AllSearchResults({
    Key? key,
    required this.results,
    this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            query == null || query!.isEmpty
                ? 'Start typing to search...'
                : 'No results found for "$query"',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'All',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ...results.map(
          (item) => ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(item['name'] ?? ''),
            subtitle: Text(item['subtitle'] ?? ''),
            onTap: () {},
          ),
        ),
        const Divider(),
      ],
    );
  }
}
