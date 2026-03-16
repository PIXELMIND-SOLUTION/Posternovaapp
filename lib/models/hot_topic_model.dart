// hot_topic_reels_model.dart

class Reel {
  final String id;
  final String videoUrl;
  final int likeCount;
  final bool hotTop;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reel({
    required this.id,
    required this.videoUrl,
    required this.likeCount,
    required this.hotTop,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['_id'] as String,
      videoUrl: json['videoUrl'] as String,
      likeCount: json['likeCount'] as int,
      hotTop: json['hotTop'] as bool,
      isLiked: json['isLiked'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'videoUrl': videoUrl,
      'likeCount': likeCount,
      'hotTop': hotTop,
      'isLiked': isLiked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Reel copyWith({
    String? id,
    String? videoUrl,
    int? likeCount,
    bool? hotTop,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      likeCount: likeCount ?? this.likeCount,
      hotTop: hotTop ?? this.hotTop,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class HotTopicReelsModel {
  final String userId;
  final List<Reel> reels;

  HotTopicReelsModel({
    required this.userId,
    required this.reels,
  });

  factory HotTopicReelsModel.fromJson(Map<String, dynamic> json) {
    return HotTopicReelsModel(
      userId: json['userId'] as String,
      reels: (json['reels'] as List<dynamic>)
          .map((e) => Reel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'reels': reels.map((e) => e.toJson()).toList(),
    };
  }
}