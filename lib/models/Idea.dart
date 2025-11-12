import 'Chain.dart';

class Idea {
  String id;
  String content;
  String authorId;
  String authorName;
  DateTime createdAt;
  int stealCount;
  List<Chain> chain;
  String? realizationPost;
  int fameScore;
  int popularityScore;
  bool isFeatured;

  Idea({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.stealCount = 0,
    this.chain = const [],
    this.realizationPost,
    this.fameScore = 0,
    this.popularityScore = 0,
    this.isFeatured = false,
  });

  int calculatePopularityScore() {
    return (stealCount * 10) + (fameScore * 5) + (chain.length * 15);
  }
}
