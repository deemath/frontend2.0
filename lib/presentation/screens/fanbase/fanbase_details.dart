import 'package:flutter/material.dart';

class FanbaseDetailScreen extends StatelessWidget {
  final String fanbaseId;

  const FanbaseDetailScreen({super.key, required this.fanbaseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fanbase #$fanbaseId')),
      body: Center(
        child: Text(
          'You are viewing Fanbase with ID: $fanbaseId',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}