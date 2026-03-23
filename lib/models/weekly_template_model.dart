// lib/models/weekly_template_model.dart

class WeeklyTemplate {
  final String id;
  final String imageUrl;
  final String categoryName;
  final String? name;
  final Map<String, dynamic>? designData;
  final String day; // Monday, Tuesday, etc.

  WeeklyTemplate({
    required this.id,
    required this.imageUrl,
    required this.categoryName,
    this.name,
    this.designData,
    required this.day,
  });

  factory WeeklyTemplate.fromJson(Map<String, dynamic> json, String day) {
    return WeeklyTemplate(
      id: json['id']?.toString() ?? '',
      imageUrl: json['images']?[0] ?? '',
      categoryName: json['categoryName'] ?? '',
      name: json['name'],
      designData: json['designData'],
      day: day,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'categoryName': categoryName,
    'name': name,
    'designData': designData,
    'day': day,
  };
}
