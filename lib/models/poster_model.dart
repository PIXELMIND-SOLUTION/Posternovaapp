class CanvasPosterModel {
  final String id;
  final String name;
  final String categoryName;
  final int price;
  final String description;
  final String size;
  final DateTime festivalDate;
  final bool inStock;
  final List<String> tags;
  final String email;
  final String mobile;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  CanvasPosterModel({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.price,
    required this.description,
    required this.size,
    required this.festivalDate,
    required this.inStock,
    required this.tags,
    required this.email,
    required this.mobile,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CanvasPosterModel.fromJson(Map<String, dynamic> json) {
    return CanvasPosterModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      categoryName: json['categoryName'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      size: json['size'] ?? '',
      festivalDate: json['festivalDate'] != null
          ? DateTime.tryParse(json['festivalDate']) ?? DateTime.now()
          : DateTime.now(),
      inStock: json['inStock'] ?? false,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'categoryName': categoryName,
      'price': price,
      'description': description,
      'size': size,
      'festivalDate': festivalDate.toIso8601String(),
      'inStock': inStock,
      'tags': tags,
      'email': email,
      'mobile': mobile,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
