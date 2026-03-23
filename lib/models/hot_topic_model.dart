// hot_topic_reels_model.dart

class ReelUser {
  final String name;
  final String email;
  final String mobile;

  ReelUser({required this.name, required this.email, required this.mobile});

  factory ReelUser.fromJson(Map<String, dynamic> json) {
    return ReelUser(
      name: json['name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'mobile': mobile};
  }
}

class Reel {
  final String id;
  final String videoUrl;
  final int likeCount;
  final bool hotTop;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReelUser user; // Add user field

  Reel({
    required this.id,
    required this.videoUrl,
    required this.likeCount,
    required this.hotTop,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
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
      user: ReelUser.fromJson(json['user'] as Map<String, dynamic>),
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
      'user': user.toJson(),
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
    ReelUser? user,
  }) {
    return Reel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      likeCount: likeCount ?? this.likeCount,
      hotTop: hotTop ?? this.hotTop,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }
}

class HotTopicReelsModel {
  final List<Reel> reels; // Remove userId field

  HotTopicReelsModel({required this.reels});

  factory HotTopicReelsModel.fromJson(Map<String, dynamic> json) {
    return HotTopicReelsModel(
      reels: (json['reels'] as List<dynamic>)
          .map((e) => Reel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'reels': reels.map((e) => e.toJson()).toList()};
  }
}
