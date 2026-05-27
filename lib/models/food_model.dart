class FoodModel {
  final String id;
  final String name;
  final String imageUrl;
  final String expiredDate;
  final String status;
  final bool isFavorite;

  FoodModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.expiredDate,
    required this.status,
    required this.isFavorite,
  });

  factory FoodModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      expiredDate: json['expired_date'],
      status: json['status'],
      isFavorite:
          json['is_favorite'] ?? false,
    );
  }

  void operator [](String other) {}
}