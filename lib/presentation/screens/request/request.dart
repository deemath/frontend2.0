import 'package:flutter/material.dart';
import '../../../data/services/request_service.dart';
import '../../../data/services/profile_service.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../widgets/home/notification.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  late Future<List<Map<String, dynamic>>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = RequestService.getPendingRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noot')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _requestsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error:  ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No pending requests found.'),
                  ));
                }
                final requests = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final senderId = request['requestSendUserId'];
                    // Use the username from the request object
                    final username = request['username'] ?? 'Unknown';
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: ProfileService().getUserProfile(senderId),
                        builder: (context, profileSnapshot) {
                          if (profileSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Row(
                              children: const [
                                SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator()),
                                SizedBox(width: 12),
                                Text('Loading...'),
                              ],
                            );
                          } else if (profileSnapshot.hasError ||
                              profileSnapshot.data == null ||
                              profileSnapshot.data!['success'] != true) {
                            return Row(
                              children: [
                                CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey[300],
                                    child: Icon(Icons.person)),
                                const SizedBox(width: 12),
                                const Text('Unknown User'),
                              ],
                            );
                          }
                          final profile = profileSnapshot.data!['data'];
                          final profileImage = profile['profileImage'] ?? '';
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey[300],
                                child: Icon(Icons.person),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'requested to follow you.',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final authProvider =
                                          Provider.of<AuthProvider>(context,
                                              listen: false);
                                      final String? currentUserId =
                                          authProvider.user?.id;
                                      if (currentUserId == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('User not logged in.')),
                                        );
                                        return;
                                      }
                                      final success =
                                          await RequestService.confirmRequest(
                                        request['requestSendUserId'],
                                        currentUserId,
                                      );
                                      if (success) {
                                        setState(() {
                                          _requestsFuture = RequestService
                                              .getPendingRequests();
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Request confirmed!')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Failed to confirm request.')),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    child: const Text('Confirm'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // TODO: Implement delete action
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Recent Activity",
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const NotificationScreen(),
          ],
        ),
      ),
    );
  }
}