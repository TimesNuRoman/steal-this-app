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
}
