class BlogPost {
  String id;
  String authorId;
  String authorName;
  String title;
  String content;
  String? imageUrl;
  DateTime createdAt;
  List<String> relatedIdeaIds;
  int viewCount;

  BlogPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.relatedIdeaIds = const [],
    this.viewCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'relatedIdeaIds': relatedIdeaIds,
      'viewCount': viewCount,
    };
  }

  static BlogPost fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      relatedIdeaIds: List<String>.from(json['relatedIdeaIds']),
      viewCount: json['viewCount'],
    );
  }
}
