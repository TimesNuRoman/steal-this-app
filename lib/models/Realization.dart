class Realization {
  String id;
  String ideaId;
  String thiefId;
  String thiefName;
  String description;
  String? imageUrl;
  DateTime createdAt;
  int likes;
  int respectGained;

  Realization({
    required this.id,
    required this.ideaId,
    required this.thiefId,
    required this.thiefName,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    this.likes = 0,
    this.respectGained = 0,
  });
}
