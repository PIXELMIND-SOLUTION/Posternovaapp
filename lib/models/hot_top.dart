// // lib/models/reel_model.dart

// class ReelModel {
//   final String id;
//   final String videoUrl;
//   final String? thumbnailUrl;
//   final String? title;
//   final String? description;
//   final int? views;
//   final int? likes;
//   final Map<String, dynamic>? metadata;
//   final bool? isLiked;

//   ReelModel({
//     required this.id,
//     required this.videoUrl,
//     this.thumbnailUrl,
//     this.title,
//     this.description,
//     this.views,
//     this.likes,
//     this.metadata,
//     this.isLiked,
//   });

//   factory ReelModel.fromJson(Map<String, dynamic> json) {
//     return ReelModel(
//       id: json['id']?.toString() ?? '',
//       videoUrl: json['videoUrl'] ?? json['video_url'] ?? '',
//       thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnail_url'],
//       title: json['title'],
//       description: json['description'],
//       views: json['views'],
//       likes: json['likes'],
//       metadata: json['metadata'],
//       isLiked: json['isLiked'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'videoUrl': videoUrl,
//     'thumbnailUrl': thumbnailUrl,
//     'title': title,
//     'description': description,
//     'views': views,
//     'likes': likes,
//     'metadata': metadata,
//     'isLiked': isLiked,
//   };
// }

class ReelModel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String title;
  final String description;
  final int views;
  final int likes;
  final bool isLiked;
  final dynamic metadata;

  ReelModel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.views,
    required this.likes,
    required this.isLiked,
    this.metadata,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      videoUrl: json['videoUrl']?.toString() ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      metadata: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'description': description,
      'views': views,
      'likes': likes,
      'isLiked': isLiked,
      ...?metadata,
    };
  }

  // Add copyWith method for immutability
  ReelModel copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? title,
    String? description,
    int? views,
    int? likes,
    bool? isLiked,
    dynamic metadata,
  }) {
    return ReelModel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      metadata: metadata ?? this.metadata,
    );
  }
}
