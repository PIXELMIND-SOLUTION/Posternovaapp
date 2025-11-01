import 'package:intl/intl.dart';

class CategoryModel {
  final String id;
  final String name;
  final String categoryName;
  final int price;
  final List<String> images;
  final String description;
  final String size;
  final DateTime? festivalDate;
  final bool inStock;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.price,
    required this.images,
    required this.description,
    required this.size,
    this.festivalDate,
    required this.inStock,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // Safe date parsing function
    DateTime? parseDateTime(dynamic dateValue) {
      if (dateValue == null) {
        return DateTime.now();
      }
      
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          // Try alternative formats
          try {
            // Try parsing with different formats
            final formats = [
              "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
              "yyyy-MM-dd'T'HH:mm:ss'Z'",
              "yyyy-MM-dd HH:mm:ss",
              "yyyy-MM-dd",
              "MM/dd/yyyy",
              "dd/MM/yyyy",
            ];
            
            for (final format in formats) {
              try {
                final formatter = DateFormat(format);
                return formatter.parse(dateValue);
              } catch (_) {
                // Continue to next format
              }
            }
            
            // If all parsing attempts fail, return current date
            print("Failed to parse date: $dateValue");
            return DateTime.now();
          } catch (_) {
            print("Failed to parse date: $dateValue");
            return DateTime.now();
          }
        }
      } else if (dateValue is int) {
        // Handle timestamp (milliseconds since epoch)
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
      
      return DateTime.now();
    }

    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      categoryName: json['categoryName'] ?? '',
      price: json['price'] is int ? json['price'] : (json['price'] is String ? int.tryParse(json['price']) ?? 0 : 0),
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      description: json['description'] ?? '',
      size: json['size'] ?? '',
      festivalDate: json['festivalDate'] != null ? parseDateTime(json['festivalDate']) : null,
      inStock: json['inStock'] ?? false,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      createdAt: parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(json['updatedAt']) ?? DateTime.now(),
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
      'festivalDate': festivalDate?.toIso8601String(),
      'inStock': inStock,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, categoryName: $categoryName, price: $price)';
  }
}