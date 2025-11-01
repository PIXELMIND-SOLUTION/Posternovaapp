class FestivalModel {
  final String id;
  final String name;
  final String categoryName;
  final int price;
  final List<String> images;
  final String description;
  final String size;
  final DateTime festivalDate;
  final bool inStock;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  FestivalModel({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.price,
    required this.images,
    required this.description,
    required this.size,
    required this.festivalDate,
    required this.inStock,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FestivalModel.fromJson(Map<String, dynamic> json) {
    return FestivalModel(
      id: json['_id'],
      name: json['name'],
      categoryName: json['categoryName'],
      price: json['price'],
      images: List<String>.from(json['images']),
      description: json['description'],
      size: json['size'],
      festivalDate: DateTime.parse(json['festivalDate']),
      inStock: json['inStock'],
      tags: List<String>.from(json['tags']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'categoryName': categoryName,
      'price': price,
      'images': images,
      'description': description,
      'size': size,
      'festivalDate': festivalDate.toIso8601String(),
      'inStock': inStock,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
