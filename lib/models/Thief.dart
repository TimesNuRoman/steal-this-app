
class Thief {
  String id;
  String name;
  String bio;
  int stolenIdeasCount;
  int realizedCount;
  int respectLevel;
  List<String> realizedIdeaIds;
  List<String> blogPosts;
  int totalFame;
  DateTime createdAt;
  String avatarUrl;

  Thief({
    required this.id,
    required this.name,
    this.bio = '',
    this.stolenIdeasCount = 0,
    this.realizedCount = 0,
    this.respectLevel = 1,
    this.realizedIdeaIds = const [],
    this.blogPosts = const [],
    this.totalFame = 0,
    required this.createdAt,
    this.avatarUrl = 'https://via.placeholder.com/100',
  });

  int calculateRespectLevel() {
    int base = 1;
    base += (stolenIdeasCount ~/ 5);
    base += (realizedCount ~/ 2);
    base += (totalFame ~/ 10);
    return base.clamp(1, 10);
  }
}
