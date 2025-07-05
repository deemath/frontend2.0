class ChatUser {
  final String id;
  final String name;
  final String profileImage;
  final bool isOnline;
  final String lastSeen;

  ChatUser({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isOnline,
    required this.lastSeen,
  });
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

class Chat {
  final String id;
  final ChatUser user;
  final Message lastMessage;
  final int unreadCount;

  Chat({
    required this.id,
    required this.user,
    required this.lastMessage,
    this.unreadCount = 0,
  });
}