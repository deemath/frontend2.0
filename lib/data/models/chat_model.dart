class ChatUser {
  final String id;
  final String username;
  final String? profileImage;
  final bool isOnline;
  final String lastSeen;

  ChatUser({
    required this.id,
    required this.username,
    this.profileImage,
    required this.isOnline,
    required this.lastSeen,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? 'Unknown User',
      profileImage: json['profileImage'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] ?? 'Unknown',
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String senderUsername;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  Message({
    required this.id,
    required this.senderId,
    required this.senderUsername,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  factory Message.fromJson(Map<String, dynamic> json, String currentUserId) {
    return Message(
      id: json['_id'] ?? json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderUsername: json['senderUsername'] ?? 'Unknown',
      text: json['text'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isMe: json['senderId'] == currentUserId,
    );
  }
}

class Chat {
  final String id;
  final ChatUser user;
  final Message? lastMessage;
  final int unreadCount;

  Chat({
    required this.id,
    required this.user,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory Chat.fromJson(Map<String, dynamic> json, String currentUserId) {
    // Find the other user (not the current user)
    final participants = json['participants'] as List<dynamic>;
    final otherUser = participants.firstWhere(
      (participant) => participant['_id'] != currentUserId,
      orElse: () => participants.first,
    );

    return Chat(
      id: json['_id'] ?? json['id'] ?? '',
      user: ChatUser.fromJson(otherUser),
      lastMessage: json['lastMessage'] != null 
          ? Message.fromJson(json['lastMessage'], currentUserId)
          : null,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}