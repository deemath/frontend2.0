class Fanbase {
  final String id;
  final String fanbaseName;
  final String topic;
  final int numLikes;
  final int numPosts;

  Fanbase({
    required this.id,
    required this.fanbaseName,
    required this.topic,
    required this.numLikes,
    required this.numPosts,
  });

  factory Fanbase.fromJson(Map<String, dynamic> json) {
    return Fanbase(
      id: json['_id'],
      fanbaseName: json['fanbaseName'],
      topic: json['description'],
      numLikes: json['numberOfLikes'] ?? 0,
      numPosts: json['numberOfComments'] ?? 0,
    );
  }
}
