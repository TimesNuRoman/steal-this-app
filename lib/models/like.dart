class Like {
  String id;
  String userId;
  String targetId;
  String targetType;
  DateTime createdAt;

  Like({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetId': targetId,
      'targetType': targetType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Like fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      userId: json['userId'],
      targetId: json['targetId'],
      targetType: json['targetType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
