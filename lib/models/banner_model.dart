// lib/models/banner_model.dart

class BannerModel {
  final String id;
  final String imageUrl;
  final String? title;
  final String? link;
  final int order;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.link,
    required this.order,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    // Handle different API response structures
    String imageUrl = '';

    if (json['images'] != null &&
        json['images'] is List &&
        json['images'].isNotEmpty) {
      imageUrl = json['images'][0];
    } else if (json['image'] != null) {
      imageUrl = json['image'];
    } else if (json['image_url'] != null) {
      imageUrl = json['image_url'];
    }

    return BannerModel(
      id: json['id']?.toString() ?? '',
      imageUrl: imageUrl,
      title: json['title'],
      link: json['link'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'title': title,
    'link': link,
    'order': order,
  };
}
