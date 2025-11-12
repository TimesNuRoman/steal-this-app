class Chain {
  String thiefId;
  String thiefName;
  DateTime stolenAt;
  String? realizationPost;
  String? comment;
  int respectGained;

  Chain({
    required this.thiefId,
    required this.thiefName,
    required this.stolenAt,
    this.realizationPost,
    this.comment,
    this.respectGained = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'thiefId': thiefId,
      'thiefName': thiefName,
      'stolenAt': stolenAt.toIso8601String(),
      'realizationPost': realizationPost,
      'comment': comment,
      'respectGained': respectGained,
    };
  }

  static Chain fromJson(Map<String, dynamic> json) {
    return Chain(
      thiefId: json['thiefId'],
      thiefName: json['thiefName'],
      stolenAt: DateTime.parse(json['stolenAt']),
      realizationPost: json['realizationPost'],
      comment: json['comment'],
      respectGained: json['respectGained'],
    );
  }
}
