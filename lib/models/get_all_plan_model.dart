
class GetAllPlanModel {
  final String id;
  final String name;
  final int originalPrice;
  final int offerPrice;
  final String? duration;
  final int discountPercentage;
  final List<String> features;
  final DateTime createdAt;
  final DateTime updatedAt;

  GetAllPlanModel({
    required this.id,
    required this.name,
    required this.originalPrice,
    required this.offerPrice,
    this.duration,
    required this.discountPercentage,
    required this.features,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetAllPlanModel.fromJson(Map<String, dynamic> json) {
    return GetAllPlanModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      originalPrice: json['originalPrice'] ?? 0,
      offerPrice: json['offerPrice'] ?? 0,
      duration: json['duration'],
      discountPercentage: json['discountPercentage'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'originalPrice': originalPrice,
      'offerPrice': offerPrice,
      'duration': duration,
      'discountPercentage': discountPercentage,
      'features': features,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}