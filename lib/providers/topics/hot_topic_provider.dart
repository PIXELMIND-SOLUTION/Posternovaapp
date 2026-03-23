// // hot_topic_reels_provider.dart

// import 'package:flutter/foundation.dart';
// import 'package:posternova/models/hot_topic_model.dart';
// import 'package:posternova/services/topic/hot_topic_service.dart';

// enum ReelsStatus { idle, loading, success, error }

// class HotTopicReelsProvider extends ChangeNotifier {
//   final HotTopicReelsService _service = HotTopicReelsService();

//   ReelsStatus _status = ReelsStatus.idle;
//   HotTopicReelsModel? _hotTopicReels;
//   String? _errorMessage;

//   ReelsStatus get status => _status;
//   HotTopicReelsModel? get hotTopicReels => _hotTopicReels;
//   List<Reel> get reels => _hotTopicReels?.reels ?? [];
//   String? get errorMessage => _errorMessage;
//   bool get isLoading => _status == ReelsStatus.loading;

//   Future<void> loadHotTopicReels(String userId) async {
//     _status = ReelsStatus.loading;
//     _errorMessage = null;
//     notifyListeners();

//     try {

//       _hotTopicReels = await _service.fetchHotTopicReels(userId);
//       _status = ReelsStatus.success;
//     } catch (e) {
//       _errorMessage = e.toString();
//       _status = ReelsStatus.error;
//     }

//     notifyListeners();
//   }

//   void toggleLike(String reelId) {
//     if (_hotTopicReels == null) return;

//     final updatedReels = _hotTopicReels!.reels.map((reel) {
//       if (reel.id == reelId) {
//         return reel.copyWith(
//           isLiked: !reel.isLiked,
//           likeCount: reel.isLiked ? reel.likeCount - 1 : reel.likeCount + 1,
//         );
//       }
//       return reel;
//     }).toList();

//     _hotTopicReels = HotTopicReelsModel(
//       userId: _hotTopicReels!.userId,
//       reels: updatedReels,
//     );

//     notifyListeners();
//   }

//   void reset() {
//     _status = ReelsStatus.idle;
//     _hotTopicReels = null;
//     _errorMessage = null;
//     notifyListeners();
//   }
// }

// lib/providers/topics/hot_topics_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/hot_top.dart';

class HotTopicsProvider extends ChangeNotifier {
  List<ReelModel> _reels = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  String? _lastUserId;

  // Getters
  List<ReelModel> get reels => _reels;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _reels.isNotEmpty;
  int get reelCount => _reels.length;

  // Get reel by index
  ReelModel? getReelByIndex(int index) {
    if (index >= 0 && index < _reels.length) {
      return _reels[index];
    }
    return null;
  }

  // Helper method to get userId
  Future<String?> _getUserId() async {
    try {
      final userData = await AuthPreferences.getUserData();
      return userData?.user.id;
    } catch (e) {
      print('Error getting userId: $e');
      return null;
    }
  }

  // Fetch hot topic reels from API
  Future<bool> fetchHotTopicReels({
    String? userId,
    bool forceRefresh = false,
  }) async {
    // If userId is not provided, get it from storage
    String? effectiveUserId = userId;
    if (effectiveUserId == null) {
      effectiveUserId = await _getUserId();
    }

    if (effectiveUserId == null) {
      _error = 'User ID not found';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // If we already have data for this user and not forcing refresh, return cached data
    if (!forceRefresh && hasData && _lastUserId == effectiveUserId) {
      print('Using cached hot topics reels data for user: $effectiveUserId');
      return true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          'http://31.97.206.144:4061/api/users/allhottopicreels/$effectiveUserId',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle different response formats
        List reelsData = [];
        if (data is List) {
          reelsData = data;
        } else if (data['reels'] is List) {
          reelsData = data['reels'];
        } else if (data['data'] is List) {
          reelsData = data['data'];
        }

        _reels = reelsData
            .map((item) => ReelModel.fromJson(item))
            .where(
              (reel) => reel.videoUrl.isNotEmpty,
            ) // Filter out reels without videos
            .toList();

        _lastUserId = effectiveUserId;
        _isLoading = false;
        _isInitialized = true;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to load hot topics reels';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Toggle like for a reel
  Future<bool> toggleLike(String reelId) async {
    try {
      // Find the reel index
      final index = _reels.indexWhere((reel) => reel.id == reelId);
      if (index == -1) return false;

      // Get current state
      final currentReel = _reels[index];
      final bool isCurrentlyLiked = currentReel.isLiked ?? false;
      final int currentLikeCount = currentReel.likes ?? 0;

      // Optimistically update UI
      _reels[index] = ReelModel(
        id: currentReel.id,
        videoUrl: currentReel.videoUrl,
        thumbnailUrl: currentReel.thumbnailUrl,
        title: currentReel.title,
        description: currentReel.description,
        views: currentReel.views,
        likes: isCurrentlyLiked ? currentLikeCount - 1 : currentLikeCount + 1,
        isLiked: !isCurrentlyLiked,
        metadata: currentReel.metadata,
      );
      notifyListeners();

      // Make API call to update like status
      final userId = await _getUserId();
      if (userId == null) {
        // Revert on error
        _reels[index] = currentReel;
        notifyListeners();
        return false;
      }

      final response = await http.post(
        Uri.parse('http://31.97.206.144:4061/api/topics/toggle-like'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'reelId': reelId,
          'action': isCurrentlyLiked ? 'unlike' : 'like',
        }),
      );

      if (response.statusCode != 200) {
        // Revert on error
        _reels[index] = currentReel;
        notifyListeners();
        return false;
      }

      // Update with server response if needed
      try {
        final responseData = jsonDecode(response.body);
        final updatedLikes =
            responseData['likes'] ??
            (isCurrentlyLiked ? currentLikeCount - 1 : currentLikeCount + 1);
        final updatedIsLiked = responseData['isLiked'] ?? !isCurrentlyLiked;

        _reels[index] = ReelModel(
          id: currentReel.id,
          videoUrl: currentReel.videoUrl,
          thumbnailUrl: currentReel.thumbnailUrl,
          title: currentReel.title,
          description: currentReel.description,
          views: currentReel.views,
          likes: updatedLikes,
          isLiked: updatedIsLiked,
          metadata: currentReel.metadata,
        );
        notifyListeners();
      } catch (e) {
        // Keep optimistic update if parsing fails
        print('Error parsing like response: $e');
      }

      return true;
    } catch (e) {
      print('Toggle like error: $e');
      return false;
    }
  }

  // Increment view count for a reel
  Future<bool> incrementViewCount(String reelId) async {
    try {
      final index = _reels.indexWhere((reel) => reel.id == reelId);
      if (index == -1) return false;

      final currentReel = _reels[index];
      final currentViews = currentReel.views ?? 0;

      // Optimistically update
      _reels[index] = ReelModel(
        id: currentReel.id,
        videoUrl: currentReel.videoUrl,
        thumbnailUrl: currentReel.thumbnailUrl,
        title: currentReel.title,
        description: currentReel.description,
        views: currentViews + 1,
        likes: currentReel.likes,
        isLiked: currentReel.isLiked,
        metadata: currentReel.metadata,
      );
      notifyListeners();

      // API call to increment view count (fire and forget)
      final userId = await _getUserId();
      if (userId != null) {
        http
            .post(
              Uri.parse('http://31.97.206.144:4061/api/topics/increment-view'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'userId': userId, 'reelId': reelId}),
            )
            .catchError((e) => print('View increment error: $e'));
      }

      return true;
    } catch (e) {
      print('Increment view error: $e');
      return false;
    }
  }

  // Manual refresh
  Future<bool> refresh() async {
    final userId = await _getUserId();
    if (userId == null) {
      _error = 'Cannot refresh: User ID not found';
      notifyListeners();
      return false;
    }
    return await fetchHotTopicReels(userId: userId, forceRefresh: true);
  }

  // Refresh with explicit userId
  Future<bool> refreshWithUserId(String userId) async {
    return await fetchHotTopicReels(userId: userId, forceRefresh: true);
  }

  // Clear data (useful for logout or user change)
  void clearData() {
    _reels = [];
    _isInitialized = false;
    _error = null;
    _lastUserId = null;
    notifyListeners();
  }

  // Get a specific reel by ID
  ReelModel? getReelById(String reelId) {
    try {
      return _reels.firstWhere((reel) => reel.id == reelId);
    } catch (e) {
      return null;
    }
  }

  // Update reel data (useful after actions)
  void updateReel(ReelModel updatedReel) {
    final index = _reels.indexWhere((reel) => reel.id == updatedReel.id);
    if (index != -1) {
      _reels[index] = updatedReel;
      notifyListeners();
    }
  }

  // Check if a reel is liked
  bool isReelLiked(String reelId) {
    final reel = getReelById(reelId);
    return reel?.isLiked ?? false;
  }

  // Get like count for a reel
  int getLikeCount(String reelId) {
    final reel = getReelById(reelId);
    return reel?.likes ?? 0;
  }
}
