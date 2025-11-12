import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Idea.dart';
import '../models/Thief.dart';
import '../models/Realization.dart';
import '../models/BlogPost.dart';
import 'RankingService.dart';

class ApiService {
  static const String _ideasKey = 'ideas';
  static const String _thievesKey = 'thieves';
  static const String _realizationsKey = 'realizations';

  static Future<List<Idea>> fetchTopIdeas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_ideasKey);
    if (data == null) return [];

    List<dynamic> jsonList = json.decode(data);
    List<Idea> ideas = jsonList.map((e) => Idea.fromJson(e)).toList();

    // Сортировка по популярности
    ideas.sort((a, b) => b.calculatePopularityScore().compareTo(a.calculatePopularityScore()));

    return ideas;
  }

  static Future<void> createIdea(String content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_ideasKey);
    List<Idea> ideas = [];

    if (data != null) {
      List<dynamic> jsonList = json.decode(data);
      ideas = jsonList.map((e) => Idea.fromJson(e)).toList();
    }

    Idea newIdea = Idea(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      authorId: 'current_user_id', // Заменить на реальный ID
      authorName: 'Roman Zaitsev',
      createdAt: DateTime.now(),
    );

    ideas.add(newIdea);
    await prefs.setString(_ideasKey, json.encode(ideas.map((e) => e.toJson()).toList()));
  }

  static Future<void> stealIdea(String ideaId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ideasData = prefs.getString(_ideasKey);
    String? thievesData = prefs.getString(_thievesKey);

    List<Idea> ideas = [];
    List<Thief> thieves = [];

    if (ideasData != null) {
      List<dynamic> jsonList = json.decode(ideasData);
      ideas = jsonList.map((e) => Idea.fromJson(e)).toList();
    }

    if (thievesData != null) {
      List<dynamic> jsonList = json.decode(thievesData);
      thieves = jsonList.map((e) => Thief.fromJson(e)).toList();
    }

    Idea? idea = ideas.firstWhere((i) => i.id == ideaId, orElse: () => throw Exception());
    idea.stealCount++;
    idea.fameScore++;

    // Найти текущего вора и обновить его
    Thief? currentThief = thieves.firstWhere((t) => t.id == 'current_user_id', orElse: () => throw Exception());
    currentThief.stolenIdeasCount++;
    currentThief.totalFame++;

    await prefs.setString(_ideasKey, json.encode(ideas.map((e) => e.toJson()).toList()));
    await prefs.setString(_thievesKey, json.encode(thieves.map((e) => e.toJson()).toList()));
  }

  static Future<void> createRealization(String ideaId, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? realizationsData = prefs.getString(_realizationsKey);

    List<Realization> realizations = [];

    if (realizationsData != null) {
      List<dynamic> jsonList = json.decode(realizationsData);
      realizations = jsonList.map((e) => Realization.fromJson(e)).toList();
    }

    Realization newRealization = Realization(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ideaId: ideaId,
      thiefId: 'current_user_id',
      thiefName: 'Roman Zaitsev',
      description: description,
      createdAt: DateTime.now(),
      respectGained: 5,
    );

    realizations.add(newRealization);
    await prefs.setString(_realizationsKey, json.encode(realizations.map((e) => e.toJson()).toList()));
  }

  static Future<Thief> fetchCurrentUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_thievesKey);
    if (data == null) throw Exception('No thieves data');

    List<dynamic> jsonList = json.decode(data);
    List<Thief> thieves = jsonList.map((e) => Thief.fromJson(e)).toList();

    Thief? thief = thieves.firstWhere((t) => t.id == 'current_user_id', orElse: () => throw Exception());
    return thief;
  }

  static Future<List<BlogPost>> fetchBlogPostsByUser(String userId) async {
    // Заглушка — в реальности будет API
    return [];
  }
}

extension on Idea {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt.toIso8601String(),
      'stealCount': stealCount,
      'fameScore': fameScore,
      'isFeatured': isFeatured,
    };
  }

  static Idea fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'],
      content: json['content'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      createdAt: DateTime.parse(json['createdAt']),
      stealCount: json['stealCount'],
      fameScore: json['fameScore'],
      isFeatured: json['isFeatured'],
    );
  }
}

extension on Thief {
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
    };
  }

  static Thief fromJson(Map<String, dynamic> json) {
    return Thief(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      stolenIdeasCount: json['stolenIdeasCount'],
      realizedCount: json['realizedCount'],
      totalFame: json['totalFame'],
      createdAt: DateTime.parse(json['createdAt']),
      avatarUrl: json['avatarUrl'],
    );
  }
}

extension on Realization {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ideaId': ideaId,
      'thiefId': thiefId,
      'thiefName': thiefName,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'respectGained': respectGained,
    };
  }

  static Realization fromJson(Map<String, dynamic> json) {
    return Realization(
      id: json['id'],
      ideaId: json['ideaId'],
      thiefId: json['thiefId'],
      thiefName: json['thiefName'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      respectGained: json['respectGained'],
    );
  }
}
