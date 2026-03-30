// lib/models/festival_poster_model.dart

class FestivalPoster {
  final String id;
  final String imageUrl;
  final String categoryName;
  final Map<String, dynamic>? designData;
  final DateTime festivalDate;
  final String? title;

  FestivalPoster({
    required this.id,
    required this.imageUrl,
    required this.categoryName,
    this.designData,
    required this.festivalDate,
    this.title,
  });

  factory FestivalPoster.fromJson(Map<String, dynamic> json, DateTime date) {
    return FestivalPoster(
      id: json['_id']?.toString() ?? '',
      imageUrl: json['images']?[0] ?? '',
      categoryName: json['categoryName'] ?? 'Festival',
      designData: json['designData'],
      festivalDate: date,
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'categoryName': categoryName,
    'designData': designData,
    'festivalDate': festivalDate.toIso8601String(),
    'title': title,
  };
}
