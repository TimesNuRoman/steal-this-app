import 'chain.dart';

class Idea {
  String id;
  String content;
  String authorId;
  String authorName;
  String? imageUrl;
  DateTime createdAt;
  int stealCount;
  List<Chain> chain;
  String? realizationPost;
  int fameScore;
  int popularityScore;
  bool isFeatured;
  int commentCount;
  double boostFactor;
  int likeCount;

  Idea({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.imageUrl,
    required this.createdAt,
    this.stealCount = 0,
    this.chain = const [],
    this.realizationPost,
    this.fameScore = 0,
    this.popularityScore = 0,
    this.isFeatured = false,
    this.commentCount = 0,
    this.boostFactor = 1.0,
    this.likeCount = 0,
  });

  int calculatePopularityScore() {
    int baseScore = (stealCount * 10) + (fameScore * 5) + (commentCount * 7) + (likeCount * 10);
    int boostedScore = (baseScore * boostFactor).toInt();
    if (createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
      boostedScore += 20;
    }
    return boostedScore;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'stealCount': stealCount,
      'fameScore': fameScore,
      'isFeatured': isFeatured,
      'commentCount': commentCount,
      'boostFactor': boostFactor,
      'likeCount': likeCount,
    };
  }

  static Idea fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'],
      content: json['content'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      stealCount: json['stealCount'],
      fameScore: json['fameScore'],
      isFeatured: json['isFeatured'],
      commentCount: json['commentCount'] ?? 0,
      boostFactor: (json['boostFactor'] as num?)?.toDouble() ?? 1.0,
      likeCount: json['likeCount'] ?? 0,
    );
  }
}
