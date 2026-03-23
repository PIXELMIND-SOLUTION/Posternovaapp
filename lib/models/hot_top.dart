// lib/models/reel_model.dart

class ReelModel {
  final String id;
  final String videoUrl;
  final String? thumbnailUrl;
  final String? title;
  final String? description;
  final int? views;
  final int? likes;
  final Map<String, dynamic>? metadata;
  final bool? isLiked;

  ReelModel({
    required this.id,
    required this.videoUrl,
    this.thumbnailUrl,
    this.title,
    this.description,
    this.views,
    this.likes,
    this.metadata,
    this.isLiked,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id']?.toString() ?? '',
      videoUrl: json['videoUrl'] ?? json['video_url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnail_url'],
      title: json['title'],
      description: json['description'],
      views: json['views'],
      likes: json['likes'],
      metadata: json['metadata'],
      isLiked: json['isLiked'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'videoUrl': videoUrl,
    'thumbnailUrl': thumbnailUrl,
    'title': title,
    'description': description,
    'views': views,
    'likes': likes,
    'metadata': metadata,
    'isLiked': isLiked,
  };
}
