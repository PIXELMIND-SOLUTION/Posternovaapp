class Reel {
  final String id;
  final String videoUrl;
  final int likeCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reel({
    required this.id,
    required this.videoUrl,
    required this.likeCount,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['_id'] as String,
      videoUrl: json['videoUrl'] as String,
      likeCount: json['likeCount'] as int,
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
      'isLiked': isLiked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  Reel copyWith({
    String? id,
    String? videoUrl,
    int? likeCount,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ReelsResponse {
  final String userId;
  final List<Reel> reels;

  ReelsResponse({
    required this.userId,
    required this.reels,
  });

  factory ReelsResponse.fromJson(Map<String, dynamic> json) {
    return ReelsResponse(
      userId: json['userId'] as String,
      reels: (json['reels'] as List)
          .map((reel) => Reel.fromJson(reel as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'reels': reels.map((reel) => reel.toJson()).toList(),
    };
  }
}

class LikeReelResponse {
  final String message;
  final String userId;
  final Reel reel;

  LikeReelResponse({
    required this.message,
    required this.userId,
    required this.reel,
  });

  factory LikeReelResponse.fromJson(Map<String, dynamic> json) {
    return LikeReelResponse(
      message: json['message'] as String,
      userId: json['userId'] as String,
      reel: Reel.fromJson(json['reel'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'reel': reel.toJson(),
    };
  }
}