class Tag {
  String id;
  String name;
  String category;
  int popularity;

  Tag({
    required this.id,
    required this.name,
    required this.category,
    this.popularity = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'popularity': popularity,
    };
  }

  static Tag fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      popularity: json['popularity'],
    );
  }
}
