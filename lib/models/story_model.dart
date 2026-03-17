// class Story {
//   final String id;
//   final String? userId;
//   final String? username;
//   final String? profileImage;
//   final List<String> images;
//   final List<String> videos;
//   final String caption;
//   final DateTime expiredAt;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final bool isViewed;

//   Story({
//     required this.id,
//     this.userId,
//     this.username,
//     this.profileImage,
//     required this.images,
//     required this.videos,
//     required this.caption,
//     required this.expiredAt,
//     required this.createdAt,
//     required this.updatedAt,
//     this.isViewed = false,
//   });

//   factory Story.fromJson(Map<String, dynamic> json) {
//     try {
//       // Handle user data more safely
//       String? userId;
//       String? username;
//       String? profileImage;

//       if (json['user'] != null) {
//         final userData = json['user'];
//         if (userData is Map<String, dynamic>) {
//           userId = userData['_id']?.toString();
//           username = userData['name']?.toString();
//           // Handle profile image - check if it's a valid URL or default
//           final userProfileImage = userData['profileImage']?.toString();
//           if (userProfileImage != null &&
//               userProfileImage.isNotEmpty &&
//               userProfileImage != 'default-profile-image.jpg') {
//             profileImage = userProfileImage;
//           } else {
//             profileImage = null; // Will use default handling
//           }
//         } else if (userData is String) {
//           // If user is just a string ID
//           userId = userData;
//         }
//       }

//       // Handle images array safely
//       List<String> images = [];
//       if (json['images'] != null && json['images'] is List) {
//         images = (json['images'] as List)
//             .map((item) => item?.toString() ?? '')
//             .where((item) => item.isNotEmpty)
//             .toList();
//       }

//       // Handle videos array safely
//       List<String> videos = [];
//       if (json['videos'] != null && json['videos'] is List) {
//         videos = (json['videos'] as List)
//             .map((item) => item?.toString() ?? '')
//             .where((item) => item.isNotEmpty)
//             .toList();
//       }

//       // Handle dates safely with proper error handling
//       DateTime expiredAt = DateTime.now().add(Duration(hours: 24));
//       if (json['expired_at'] != null) {
//         try {
//           expiredAt = DateTime.parse(json['expired_at'].toString());
//         } catch (e) {
//           print('Error parsing expired_at: $e');
//         }
//       }

//       DateTime createdAt = DateTime.now();
//       if (json['createdAt'] != null) {
//         try {
//           createdAt = DateTime.parse(json['createdAt'].toString());
//         } catch (e) {
//           print('Error parsing createdAt: $e');
//         }
//       }

//       DateTime updatedAt = DateTime.now();
//       if (json['updatedAt'] != null) {
//         try {
//           updatedAt = DateTime.parse(json['updatedAt'].toString());
//         } catch (e) {
//           print('Error parsing updatedAt: $e');
//         }
//       }

//       return Story(
//         id: json['_id']?.toString() ?? '',
//         userId: userId,
//         username: username,
//         profileImage: profileImage,
//         images: images,
//         videos: videos,
//         caption: json['caption']?.toString() ?? '',
//         expiredAt: expiredAt,
//         createdAt: createdAt,
//         updatedAt: updatedAt,
//       );
//     } catch (e) {
//       print('Error in Story.fromJson: $e');
//       print('JSON data: $json');
//       rethrow;
//     }
//   }

//   Story copyWith({bool? isViewed}) {
//     return Story(
//       id: id,
//       userId: userId,
//       username: username,
//       profileImage: profileImage,
//       images: images,
//       videos: videos,
//       caption: caption,
//       expiredAt: expiredAt,
//       createdAt: createdAt,
//       updatedAt: updatedAt,
//       isViewed: isViewed ?? this.isViewed,
//     );
//   }

//   // Helper method to check if story has expired
//   bool get isExpired => DateTime.now().isAfter(expiredAt);

//   // Helper method to get display name
//   String get displayName => username ?? 'Anonymous';

//   // Helper method to get profile image with fallback
//   String get displayProfileImage {
//     if (profileImage != null &&
//         profileImage!.isNotEmpty &&
//         profileImage != 'default-profile-image.jpg') {
//       return profileImage!;
//     }
//     return 'default-profile-image.jpg';
//   }

//   // Helper method to check if user has a custom profile image
//   bool get hasCustomProfileImage {
//     return profileImage != null &&
//            profileImage!.isNotEmpty &&
//            profileImage != 'default-profile-image.jpg';
//   }

//   // Convert to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'user': userId != null ? {
//         '_id': userId,
//         'name': username,
//         'profileImage': profileImage,
//       } : null,
//       'images': images,
//       'videos': videos,
//       'caption': caption,
//       'expired_at': expiredAt.toIso8601String(),
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       'isViewed': isViewed,
//     };
//   }
// }

// UserStories helper class to group stories by user
// UserStories helper class to group stories by user
class UserStories {
  final String? userId;
  final String username;
  final String userAvatar;
  final String? userLanguage;
  final List<Story> stories;

  UserStories({
    this.userId,
    required this.stories,
    this.username = '',
    this.userAvatar = '',
    this.userLanguage,
  });

  factory UserStories.fromStories(List<Story> stories) {
    if (stories.isEmpty) {
      return UserStories(stories: []);
    }

    // Group stories by user
    Map<String?, List<Story>> groupedStories = {};
    for (Story story in stories) {
      String? key = story.userId;
      if (!groupedStories.containsKey(key)) {
        groupedStories[key] = [];
      }
      groupedStories[key]!.add(story);
    }

    // For now, return the first user's stories
    // You might want to modify this based on your needs
    var firstUserStories = groupedStories.values.first;
    var firstStory = firstUserStories.first;

    return UserStories(
      userId: firstStory.userId,
      username: firstStory.username ?? 'Anonymous',
      userAvatar: firstStory.displayProfileImage,
      userLanguage: firstStory.userLanguage,
      stories: firstUserStories,
    );
  }

  factory UserStories.fromJson(Map<String, dynamic> json) {
    try {
      List<Story> stories = [];
      if (json['stories'] != null && json['stories'] is List) {
        for (var storyData in json['stories']) {
          try {
            stories.add(Story.fromJson(storyData));
          } catch (e) {
            print('Error parsing individual story in UserStories: $e');
          }
        }
      }

      String? userId;
      String username = '';
      String userAvatar = '';
      String? userLanguage;

      if (stories.isNotEmpty) {
        final firstStory = stories.first;
        userId = firstStory.userId;
        username = firstStory.username ?? '';
        userAvatar = firstStory.displayProfileImage;
        userLanguage = firstStory.userLanguage;
      }

      return UserStories(
        userId: userId,
        username: username,
        userAvatar: userAvatar,
        userLanguage: userLanguage,
        stories: stories,
      );
    } catch (e) {
      print('Error in UserStories.fromJson: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Check if any stories are unviewed
  bool get hasUnviewedStories => stories.any((story) => !story.isViewed);

  // Get active (non-expired) stories
  List<Story> get activeStories =>
      stories.where((story) => !story.isExpired).toList();

  // Get expired stories
  List<Story> get expiredStories =>
      stories.where((story) => story.isExpired).toList();

  // Get first media URL for preview
  String? get firstMediaUrl {
    if (stories.isNotEmpty) {
      return stories.first.firstMediaUrl;
    }
    return null;
  }

  // Check if first story has video
  bool get hasVideo {
    if (stories.isNotEmpty) {
      return stories.first.hasVideos;
    }
    return false;
  }
}

// Helper class to parse the API response
// Helper class to parse the API response
class StoriesResponse {
  final String message;
  final List<Story> stories;

  StoriesResponse({required this.message, required this.stories});

  factory StoriesResponse.fromJson(Map<String, dynamic> json) {
    try {
      List<Story> stories = [];
      if (json['stories'] != null && json['stories'] is List) {
        for (var storyData in json['stories']) {
          try {
            stories.add(Story.fromJson(storyData));
          } catch (e) {
            print('Error parsing individual story in StoriesResponse: $e');
          }
        }
      }

      return StoriesResponse(
        message: json['message']?.toString() ?? '',
        stories: stories,
      );
    } catch (e) {
      print('Error in StoriesResponse.fromJson: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Group stories by user
  Map<String?, List<Story>> get storiesByUser {
    Map<String?, List<Story>> grouped = {};
    for (Story story in stories) {
      String? key = story.userId;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(story);
    }
    return grouped;
  }

  // Get list of UserStories objects
  List<UserStories> get userStoriesList {
    return storiesByUser.entries.map((entry) {
      List<Story> userStories = entry.value;
      if (userStories.isEmpty) return UserStories(stories: []);

      Story firstStory = userStories.first;
      return UserStories(
        userId: firstStory.userId,
        username: firstStory.username ?? 'Anonymous',
        userAvatar: firstStory.displayProfileImage,
        userLanguage: firstStory.userLanguage,
        stories: userStories,
      );
    }).toList();
  }
}

class Story {
  final String id;
  final String? userId;
  final String? username;
  final String? profileImage;
  final String? userLanguage;
  final List<String> images;
  final List<String> videos;
  final String caption;
  final DateTime expiredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isViewed;

  Story({
    required this.id,
    this.userId,
    this.username,
    this.profileImage,
    this.userLanguage,
    required this.images,
    required this.videos,
    required this.caption,
    required this.expiredAt,
    required this.createdAt,
    required this.updatedAt,
    this.isViewed = false,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    try {
      // Handle user data (which is an object in your response)
      String? userId;
      String? username;
      String? profileImage;
      String? userLanguage;

      if (json['user'] != null && json['user'] is Map<String, dynamic>) {
        final userData = json['user'] as Map<String, dynamic>;
        userId = userData['_id']?.toString();
        username = userData['name']?.toString();
        userLanguage = userData['language']?.toString();

        // Handle profile image
        final userProfileImage = userData['profileImage']?.toString();
        if (userProfileImage != null &&
            userProfileImage.isNotEmpty &&
            userProfileImage != 'default-profile-image.jpg') {
          profileImage = userProfileImage;
        }
      }

      // Handle videos array
      List<String> videos = [];
      if (json['videos'] != null && json['videos'] is List) {
        videos = (json['videos'] as List)
            .map((item) => item?.toString() ?? '')
            .where((item) => item.isNotEmpty)
            .toList();
      }

      // Handle images array
      List<String> images = [];
      if (json['images'] != null && json['images'] is List) {
        images = (json['images'] as List)
            .map((item) => item?.toString() ?? '')
            .where((item) => item.isNotEmpty)
            .toList();
      }

      // Handle expired_at date
      DateTime expiredAt = DateTime.now().add(const Duration(hours: 24));
      if (json['expired_at'] != null) {
        try {
          expiredAt = DateTime.parse(json['expired_at'].toString());
        } catch (e) {
          print('Error parsing expired_at: $e');
        }
      }

      // Handle createdAt date
      DateTime createdAt = DateTime.now();
      if (json['createdAt'] != null) {
        try {
          createdAt = DateTime.parse(json['createdAt'].toString());
        } catch (e) {
          print('Error parsing createdAt: $e');
        }
      }

      // Handle updatedAt date
      DateTime updatedAt = DateTime.now();
      if (json['updatedAt'] != null) {
        try {
          updatedAt = DateTime.parse(json['updatedAt'].toString());
        } catch (e) {
          print('Error parsing updatedAt: $e');
        }
      }

      return Story(
        id: json['_id']?.toString() ?? '',
        userId: userId,
        username: username,
        profileImage: profileImage,
        userLanguage: userLanguage,
        images: images,
        videos: videos,
        caption: json['caption']?.toString() ?? '',
        expiredAt: expiredAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      print('Error in Story.fromJson: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Story copyWith({bool? isViewed}) {
    return Story(
      id: id,
      userId: userId,
      username: username,
      profileImage: profileImage,
      userLanguage: userLanguage,
      images: images,
      videos: videos,
      caption: caption,
      expiredAt: expiredAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isViewed: isViewed ?? this.isViewed,
    );
  }

  // Helper method to check if story has expired
  bool get isExpired => DateTime.now().isAfter(expiredAt);

  // Helper method to get display name
  String get displayName => username ?? 'Anonymous';

  // Helper method to get profile image with fallback
  String get displayProfileImage {
    if (profileImage != null &&
        profileImage!.isNotEmpty &&
        profileImage != 'default-profile-image.jpg') {
      return profileImage!;
    }
    return 'default-profile-image.jpg';
  }

  // Helper method to check if user has a custom profile image
  bool get hasCustomProfileImage {
    return profileImage != null &&
        profileImage!.isNotEmpty &&
        profileImage != 'default-profile-image.jpg';
  }

  // Helper method to get first media URL (video takes priority as in your response)
  String? get firstMediaUrl {
    if (videos.isNotEmpty) {
      return videos.first;
    } else if (images.isNotEmpty) {
      return images.first;
    }
    return null;
  }

  // Helper method to check if story has videos
  bool get hasVideos => videos.isNotEmpty;

  // Helper method to check if story has images
  bool get hasImages => images.isNotEmpty;

  // Helper method to get media type
  String get mediaType {
    if (hasVideos) return 'video';
    if (hasImages) return 'image';
    return 'none';
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': {
        '_id': userId,
        'name': username,
        'profileImage': profileImage,
        'language': userLanguage,
      },
      'images': images,
      'videos': videos,
      'caption': caption,
      'expired_at': expiredAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
