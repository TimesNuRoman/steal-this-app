
class Profile {
  String id;
  String name;
  String bio;
  int stolenIdeasCount;
  int realizedCount;
  int respectLevel;
  int totalFame;
  DateTime createdAt;
  String avatarUrl;
  List<String> blogPostIds;
  List<String> tags;
  int engagementScore;
  Map<String, int> categoryScores;
  double totalEarningsFromOthers;
  int currencyBalance;
  List<String> subscriptions;
  String? telegram;
  String? whatsapp;
  String? discord;
  String? email;

  Profile({
    required this.id,
    required this.name,
    this.bio = '',
    this.stolenIdeasCount = 0,
    this.realizedCount = 0,
    this.respectLevel = 1,
    this.totalFame = 0,
    required this.createdAt,
    this.avatarUrl = 'https://via.placeholder.com/100',
    this.blogPostIds = const [],
    this.tags = const [],
    this.engagementScore = 0,
    this.categoryScores = const {},
    this.totalEarningsFromOthers = 0.0,
    this.currencyBalance = 0,
    this.subscriptions = const [],
    this.telegram,
    this.whatsapp,
    this.discord,
    this.email,
  });

  int calculateRespectLevel() {
    int base = 1;
    base += (stolenIdeasCount ~/ 5);
    base += (realizedCount ~/ 2);
    base += (totalFame ~/ 10);
    return base.clamp(1, 10);
  }

  int calculateInfluenceLevel() {
    if (totalEarningsFromOthers < 100) return 1;
    if (totalEarningsFromOthers < 500) return 2;
    if (totalEarningsFromOthers < 1000) return 3;
    if (totalEarningsFromOthers < 5000) return 4;
    return 5;
  }

  double calculateIdeaBoostFactor() {
    int level = calculateInfluenceLevel();
    return [1.0, 1.2, 1.5, 2.0, 2.5][level - 1];
  }

  double calculateMonetizationPotential() {
    double baseScore = engagementScore.toDouble();
    for (String category in categoryScores.keys) {
      if (['IT', 'Бизнес', 'Маркетинг', 'Финансы'].contains(category)) {
        baseScore *= 1.5;
      }
    }
    if (tags.length > 3) {
      baseScore *= 1.2;
    }
    return baseScore.clamp(0, 10000).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'stolenIdeasCount': stolenIdeasCount,
      'realizedCount': realizedCount,
      'totalFame': totalFame,
      'createdAt': createdAt.toIso8601String(),
      'avatarUrl': avatarUrl,
      'blogPostIds': blogPostIds,
      'tags': tags,
      'engagementScore': engagementScore,
      'categoryScores': categoryScores,
      'totalEarningsFromOthers': totalEarningsFromOthers,
      'currencyBalance': currencyBalance,
      'subscriptions': subscriptions,
      'telegram': telegram,
      'whatsapp': whatsapp,
      'discord': discord,
      'email': email,
    };
  }

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      stolenIdeasCount: json['stolenIdeasCount'],
      realizedCount: json['realizedCount'],
      totalFame: json['totalFame'],
      createdAt: DateTime.parse(json['createdAt']),
      avatarUrl: json['avatarUrl'],
      blogPostIds: List<String>.from(json['blogPostIds']),
      tags: List<String>.from(json['tags']),
      engagementScore: json['engagementScore'],
      categoryScores: Map<String, dynamic>.from(json['categoryScores']).map((key, value) => MapEntry(key, value as int)),
      totalEarningsFromOthers: (json['totalEarningsFromOthers'] as num?)?.toDouble() ?? 0.0,
      currencyBalance: json['currencyBalance'] ?? 0,
      subscriptions: List<String>.from(json['subscriptions'] ?? []),
      telegram: json['telegram'],
      whatsapp: json['whatsapp'],
      discord: json['discord'],
      email: json['email'],
    );
  }
}
