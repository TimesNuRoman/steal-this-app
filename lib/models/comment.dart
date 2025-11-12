class Comment {
  String id;
  String authorId;
  String authorName;
  String content;
  DateTime createdAt;
  String targetId;
  String targetType;

  Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
    required this.targetId,
    required this.targetType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'targetId': targetId,
      'targetType': targetType,
    };
  }

  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      targetId: json['targetId'],
      targetType: json['targetType'],
    );
  }
}
