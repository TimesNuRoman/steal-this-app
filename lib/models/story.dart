class Story {
  String id;
  String authorId;
  String authorName;
  String? imageUrl;
  String? text;
  DateTime createdAt;
  DateTime expiresAt;

  Story({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.imageUrl,
    this.text,
    required this.createdAt,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'imageUrl': imageUrl,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  static Story fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      imageUrl: json['imageUrl'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}
