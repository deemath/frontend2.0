import 'package:flutter/material.dart';

class CreateNewNootPage extends StatelessWidget {
  final Map<String, dynamic> track;

  const CreateNewNootPage({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Noot')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (track['album'] != null && track['album'].toString().isNotEmpty)
              Center(
                child: Image.network(track['album'], width: 150, height: 150),
              ),
            const SizedBox(height: 16),
            Text('Track Name: ${track['name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Artists: ${track['artists'] is List ? track['artists'].join(", ") : track['artists'].toString()}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Track ID: ${track['id']}', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
