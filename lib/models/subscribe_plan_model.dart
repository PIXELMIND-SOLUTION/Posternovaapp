
class SubscribePlanModel {
  final String id;
  final String name;
  final int originalPrice;
  final int offerPrice;
  final int discountPercentage;
  final String duration;
  final DateTime? startDate; // Made nullable
  final DateTime? endDate;   // Made nullable
  final bool isSubscribedPlan;
  final bool isSelected;

  SubscribePlanModel({
    required this.id,
    required this.name,
    required this.originalPrice,
    required this.offerPrice,
    required this.discountPercentage,
    required this.duration,
    this.startDate, // Nullable
    this.endDate,   // Nullable
    required this.isSubscribedPlan,
    this.isSelected = false,
  });

  factory SubscribePlanModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing plan JSON: $json');
      
      return SubscribePlanModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        originalPrice: _parseIntSafely(json['originalPrice']),
        offerPrice: _parseIntSafely(json['offerPrice']),
        discountPercentage: _parseIntSafely(json['discountPercentage']),
        duration: json['duration']?.toString() ?? '',
        startDate: _parseDateSafely(json['startDate']),
        endDate: _parseDateSafely(json['endDate']),
        // Use isPurchasedPlan from API response instead of isSubscribedPlan
        isSubscribedPlan: json['isPurchasedPlan'] == true || json['isActive'] == true,
        isSelected: json['isSelected'] == true,
      );
    } catch (e) {
      print('❌ Error parsing SubscribePlanModel: $e');
      print('📄 JSON data: $json');
      rethrow;
    }
  }

  // Helper method to safely parse integers
  static int _parseIntSafely(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) return value.round();
    return 0;
  }

  // Helper method to safely parse dates
  static DateTime? _parseDateSafely(dynamic value) {
    if (value == null) return null;
    
    try {
      if (value is String && value.isNotEmpty) {
        // Handle the date format from your API: "2025/07/18"
        if (value.contains('/')) {
          // Convert "2025/07/18" to "2025-07-18" for DateTime.parse
          final parts = value.split('/');
          if (parts.length == 3) {
            final formattedDate = '${parts[0]}-${parts[1].padLeft(2, '0')}-${parts[2].padLeft(2, '0')}';
            return DateTime.parse(formattedDate);
          }
        }
        return DateTime.parse(value);
      }
    } catch (e) {
      print('❌ Error parsing date: $value, Error: $e');
    }
    
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'originalPrice': originalPrice,
      'offerPrice': offerPrice,
      'discountPercentage': discountPercentage,
      'duration': duration,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isSubscribedPlan': isSubscribedPlan,
      'isSelected': isSelected,
    };
  }

  // Helper method to create a copy with updated values
  SubscribePlanModel copyWith({
    String? id,
    String? name,
    int? originalPrice,
    int? offerPrice,
    int? discountPercentage,
    String? duration,
    DateTime? startDate,
    DateTime? endDate,
    bool? isPurchasedPlan,
    bool? isSelected,
  }) {
    return SubscribePlanModel(
      id: id ?? this.id,
      name: name ?? this.name,
      originalPrice: originalPrice ?? this.originalPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isSubscribedPlan: isPurchasedPlan ?? this.isSubscribedPlan,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return 'SubscribePlanModel{id: $id, name: $name, originalPrice: $originalPrice, offerPrice: $offerPrice, discountPercentage: $discountPercentage, duration: $duration, startDate: $startDate, endDate: $endDate, isSubscribedPlan: $isSubscribedPlan, isSelected: $isSelected}';
  }
}