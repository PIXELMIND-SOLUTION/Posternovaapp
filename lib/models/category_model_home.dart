// lib/models/category_model.dart

class CategoryPoster {
  final String id;
  final String imageUrl;
  final String categoryName;
  final Map<String, dynamic>? designData;
  final String? title;
  final int? order;

  CategoryPoster({
    required this.id,
    required this.imageUrl,
    required this.categoryName,
    this.designData,
    this.title,
    this.order,
  });

  factory CategoryPoster.fromJson(Map<String, dynamic> json) {
    return CategoryPoster(
      id: json['id']?.toString() ?? '',
      imageUrl: json['images']?[0] ?? '',
      categoryName: json['categoryName'] ?? '',
      designData: json['designData'],
      title: json['title'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'categoryName': categoryName,
    'designData': designData,
    'title': title,
    'order': order,
  };
}
