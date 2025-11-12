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
}
