// /// Model for the poster categories API
// /// GET http://31.97.228.17:4061/api/poster/categories
// class PosterCategoryModel {
//   final String id;
//   final String name;
//   final String image;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   PosterCategoryModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory PosterCategoryModel.fromJson(Map<String, dynamic> json) {
//     return PosterCategoryModel(
//       id: json['_id'] as String,
//       name: json['name'] as String,
//       image: json['image'] as String,
//       createdAt: DateTime.parse(json['createdAt'] as String),
//       updatedAt: DateTime.parse(json['updatedAt'] as String),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'name': name,
//         'image': image,
//         'createdAt': createdAt.toIso8601String(),
//         'updatedAt': updatedAt.toIso8601String(),
//       };
// }

// class PosterCategoriesResponse {
//   final bool success;
//   final List<PosterCategoryModel> categories;

//   PosterCategoriesResponse({
//     required this.success,
//     required this.categories,
//   });

//   factory PosterCategoriesResponse.fromJson(Map<String, dynamic> json) {
//     return PosterCategoriesResponse(
//       success: json['success'] as bool,
//       categories: (json['categories'] as List<dynamic>)
//           .map((e) => PosterCategoryModel.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }























// ─── Category Model ───────────────────────────────────────────────────────────

class PosterCategoryModel {
  final String id;
  final String name;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  PosterCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PosterCategoryModel.fromJson(Map<String, dynamic> json) {
    return PosterCategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'image': image,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class PosterCategoriesResponse {
  final bool success;
  final List<PosterCategoryModel> categories;

  PosterCategoriesResponse({
    required this.success,
    required this.categories,
  });

  factory PosterCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return PosterCategoriesResponse(
      success: json['success'] as bool,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => PosterCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ─── Subcategory / Poster Model ───────────────────────────────────────────────

class BgImageModel {
  final String url;
  final String publicId;

  BgImageModel({required this.url, required this.publicId});

  factory BgImageModel.fromJson(Map<String, dynamic> json) => BgImageModel(
        url: json['url'] as String,
        publicId: json['publicId'] as String,
      );

  Map<String, dynamic> toJson() => {'url': url, 'publicId': publicId};
}

class OverlayImageModel {
  final String id;
  final String url;
  final String publicId;

  OverlayImageModel({
    required this.id,
    required this.url,
    required this.publicId,
  });

  factory OverlayImageModel.fromJson(Map<String, dynamic> json) =>
      OverlayImageModel(
        id: json['_id'] as String,
        url: json['url'] as String,
        publicId: json['publicId'] as String,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'url': url,
        'publicId': publicId,
      };
}

class OverlayPosition {
  final double x;
  final double y;
  final double width;
  final double height;

  OverlayPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory OverlayPosition.fromJson(Map<String, dynamic> json) =>
      OverlayPosition(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };
}

class DesignDataModel {
  final BgImageModel bgImage;
  final List<OverlayImageModel> overlayImages;
  final Map<String, dynamic> bgImageSettings;
  final List<OverlayPosition> overlays;
  final Map<String, dynamic> textSettings;
  final Map<String, dynamic> textStyles;
  final Map<String, dynamic> textVisibility;
  final List<dynamic> overlayImageFilters;

  DesignDataModel({
    required this.bgImage,
    required this.overlayImages,
    required this.bgImageSettings,
    required this.overlays,
    required this.textSettings,
    required this.textStyles,
    required this.textVisibility,
    required this.overlayImageFilters,
  });

  factory DesignDataModel.fromJson(Map<String, dynamic> json) {
    final overlaySettings =
        json['overlaySettings'] as Map<String, dynamic>? ?? {};
    final overlaysList =
        (overlaySettings['overlays'] as List<dynamic>? ?? [])
            .map((e) => OverlayPosition.fromJson(e as Map<String, dynamic>))
            .toList();

    return DesignDataModel(
      bgImage: BgImageModel.fromJson(
          json['bgImage'] as Map<String, dynamic>),
      overlayImages: (json['overlayImages'] as List<dynamic>? ?? [])
          .map((e) =>
              OverlayImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bgImageSettings:
          json['bgImageSettings'] as Map<String, dynamic>? ?? {},
      overlays: overlaysList,
      textSettings:
          json['textSettings'] as Map<String, dynamic>? ?? {},
      textStyles: json['textStyles'] as Map<String, dynamic>? ?? {},
      textVisibility:
          json['textVisibility'] as Map<String, dynamic>? ?? {},
      overlayImageFilters:
          json['overlayImageFilters'] as List<dynamic>? ?? [],
    );
  }
}

class PosterSubcategoryModel {
  final String id;
  final String categoryId;
  final String name;
  final String categoryName;
  final DateTime festivalDate;
  final String description;
  final List<String> tags;
  final String email;
  final String mobile;
  final String title;
  final String posterLang;
  final bool isTrending;
  final String posterImage;
  final List<String> images;
  final DesignDataModel designData;
  final DateTime createdAt;
  final DateTime updatedAt;

  PosterSubcategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.categoryName,
    required this.festivalDate,
    required this.description,
    required this.tags,
    required this.email,
    required this.mobile,
    required this.title,
    required this.posterLang,
    required this.isTrending,
    required this.posterImage,
    required this.images,
    required this.designData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PosterSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return PosterSubcategoryModel(
      id: json['_id'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      categoryName: json['categoryName'] as String,
      festivalDate: DateTime.parse(json['festivalDate'] as String),
      description: json['description'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      title: json['title'] as String,
      posterLang: json['posterlang'] as String,
      isTrending: json['isTrending'] as bool,
      posterImage: json['posterImage'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      designData: DesignDataModel.fromJson(
          json['designData'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class PosterSubcategoriesResponse {
  final bool success;
  final String message;
  final String categoryId;
  final String categoryName;
  final int count;
  final List<PosterSubcategoryModel> posters;

  PosterSubcategoriesResponse({
    required this.success,
    required this.message,
    required this.categoryId,
    required this.categoryName,
    required this.count,
    required this.posters,
  });

  factory PosterSubcategoriesResponse.fromJson(Map<String, dynamic> json) {
    return PosterSubcategoriesResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      count: json['count'] as int,
      posters: (json['posters'] as List<dynamic>)
          .map((e) => PosterSubcategoryModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );
  }
}