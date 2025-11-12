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
  bool isForSale;
  double? price;
  String? currency;
  String? orderLink;

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
    this.isForSale = false,
    this.price,
    this.currency = 'RUB',
    this.orderLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ideaId': ideaId,
      'thiefId': thiefId,
      'thiefName': thiefName,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'respectGained': respectGained,
      'isForSale': isForSale,
      'price': price,
      'currency': currency,
      'orderLink': orderLink,
    };
  }

  static Realization fromJson(Map<String, dynamic> json) {
    return Realization(
      id: json['id'],
      ideaId: json['ideaId'],
      thiefId: json['thiefId'],
      thiefName: json['thiefName'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      likes: json['likes'],
      respectGained: json['respectGained'],
      isForSale: json['isForSale'] ?? false,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] ?? 'RUB',
      orderLink: json['orderLink'],
    );
  }
}
