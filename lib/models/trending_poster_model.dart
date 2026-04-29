class TrendingPosterResponse {
  final List<TrendingPoster> posters;

  TrendingPosterResponse({required this.posters});

  factory TrendingPosterResponse.fromJson(List<dynamic> json) {
    return TrendingPosterResponse(
      posters: json.map((e) => TrendingPoster.fromJson(e)).toList(),
    );
  }
}

// class TrendingPoster {
//   final String id;
//   final String name;
//   final String categoryName;
//   final String title;
//   final String description;
//   final String size;
//   final bool inStock;
//   final bool isTrending;
//   final DateTime festivalDate;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final List<String> images;
//   final List<String> tags;
//   final PosterImage posterImage;
//   final DesignData designData;

//   TrendingPoster({
//     required this.id,
//     required this.name,
//     required this.categoryName,
//     required this.title,
//     required this.description,
//     required this.size,
//     required this.inStock,
//     required this.isTrending,
//     required this.festivalDate,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.images,
//     required this.tags,
//     required this.posterImage,
//     required this.designData,
//   });

//   factory TrendingPoster.fromJson(Map<String, dynamic> json) {
//     return TrendingPoster(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       categoryName: json['categoryName'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       size: json['size'] ?? '',
//       inStock: json['inStock'] ?? false,
//       isTrending: json['isTrending'] ?? false,
//       festivalDate: DateTime.parse(json['festivalDate']),
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       images: List<String>.from(json['images'] ?? []),
//       tags: List<String>.from(json['tags'] ?? []),
//       posterImage: PosterImage.fromJson(json['posterImage']),
//       designData: DesignData.fromJson(json['designData']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'categoryName': categoryName,
//       'title': title,
//       'description': description,
//       'size': size,
//       'inStock': inStock,
//       'isTrending': isTrending,
//       'festivalDate': festivalDate.toIso8601String(),
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       'images': images,
//       'tags': tags,
//       'posterImage': posterImage.toJson(),
//       'designData': designData.toJson(),
//     };
//   }
// }






class TrendingPoster {
  final String id;
  final String name;
  final String categoryName;
  final String title;
  final String description;
  final String size;
  final bool inStock;
  final bool isTrending;
  final DateTime? festivalDate;   // ← nullable, it's absent in some responses
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> images;
  final List<String> tags;
  final PosterImage posterImage;
  final DesignData designData;

  TrendingPoster({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.title,
    required this.description,
    required this.size,
    required this.inStock,
    required this.isTrending,
    this.festivalDate,             // ← optional
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.tags,
    required this.posterImage,
    required this.designData,
  });

  factory TrendingPoster.fromJson(Map<String, dynamic> json) {
    return TrendingPoster(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      categoryName: json['categoryName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      size: json['size'] ?? '',
      inStock: json['inStock'] ?? false,
      isTrending: json['isTrending'] ?? false,
      // ✅ safe parse — field may be absent
      festivalDate: json['festivalDate'] != null
          ? DateTime.tryParse(json['festivalDate'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      images: List<String>.from(json['images'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      posterImage: PosterImage.fromJson(json['posterImage'] ?? {}),
      designData: DesignData.fromJson(json['designData'] ?? {}),
    );
  }
}

class PosterImage {
  final String url;
  final String publicId;

  PosterImage({required this.url, required this.publicId});

  factory PosterImage.fromJson(Map<String, dynamic> json) {
    return PosterImage(
      url: json['url'] ?? '',
      publicId: json['publicId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'publicId': publicId};
}

class DesignData {
  final BgImage bgImage;
  final List<dynamic> overlayImages;

  DesignData({required this.bgImage, required this.overlayImages});

  factory DesignData.fromJson(Map<String, dynamic> json) {
    return DesignData(
      bgImage: BgImage.fromJson(json['bgImage'] ?? {}),
      overlayImages: json['overlayImages'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'bgImage': bgImage.toJson(),
        'overlayImages': overlayImages,
      };
}

class BgImage {
  final String url;
  final String publicId;

  BgImage({required this.url, required this.publicId});

  factory BgImage.fromJson(Map<String, dynamic> json) {
    return BgImage(
      url: json['url'] ?? '',
      publicId: json['publicId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'publicId': publicId};
}