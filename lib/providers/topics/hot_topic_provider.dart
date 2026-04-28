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
      debugPrint('Error getting userId: $e');
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
      debugPrint(
        'Using cached hot topics reels data for user: $effectiveUserId',
      );
      return true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          'http://82.29.162.67:4061/api/users/allhottopicreels/$effectiveUserId',
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

  // Toggle like for a reel - FIXED VERSION
  Future<bool> toggleLike(String reelId) async {
    try {
      // Find the reel index
      final index = _reels.indexWhere((reel) => reel.id == reelId);
      if (index == -1) {
        debugPrint('Reel not found: $reelId');
        return false;
      }

      // Get current state
      final currentReel = _reels[index];
      final bool isCurrentlyLiked = currentReel.isLiked ?? false;
      final int currentLikeCount = currentReel.likes ?? 0;

      debugPrint('Toggling like for reel: $reelId');
      debugPrint(
        'Current state - Liked: $isCurrentlyLiked, Likes: $currentLikeCount',
      );

      // Optimistically update UI
      _reels[index] = currentReel.copyWith(
        isLiked: !isCurrentlyLiked,
        likes: isCurrentlyLiked ? currentLikeCount - 1 : currentLikeCount + 1,
      );
      notifyListeners();

      // Get userId for API call
      final userId = await _getUserId();
      if (userId == null) {
        debugPrint('User ID not found, reverting optimistic update');
        // Revert on error
        _reels[index] = currentReel;
        notifyListeners();
        return false;
      }

      // Make API call to update like status
      final response = await http.post(
        Uri.parse('http://82.29.162.67:4061/api/topics/toggle-like'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'reelId': reelId,
          'action': isCurrentlyLiked ? 'unlike' : 'like',
        }),
      );

      debugPrint('API Response Status: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse server response
        try {
          final responseData = jsonDecode(response.body);

          // Update with server values if provided
          final updatedLikes =
              responseData['likes'] ??
              (isCurrentlyLiked ? currentLikeCount - 1 : currentLikeCount + 1);
          final updatedIsLiked = responseData['isLiked'] ?? !isCurrentlyLiked;

          _reels[index] = currentReel.copyWith(
            isLiked: updatedIsLiked,
            likes: updatedLikes,
          );
          notifyListeners();

          debugPrint(
            'Like toggled successfully - New likes: $updatedLikes, Is liked: $updatedIsLiked',
          );
        } catch (e) {
          debugPrint('Error parsing response, keeping optimistic update: $e');
          // Keep optimistic update if parsing fails
        }
        return true;
      } else {
        // API call failed, revert optimistic update
        debugPrint('API call failed with status: ${response.statusCode}');
        _reels[index] = currentReel;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Toggle like error: $e');
      // Try to find and revert the reel
      final index = _reels.indexWhere((reel) => reel.id == reelId);
      if (index != -1) {
        final currentReel = _reels[index];
        final bool isCurrentlyLiked = currentReel.isLiked ?? false;
        final int currentLikeCount = currentReel.likes ?? 0;

        _reels[index] = currentReel.copyWith(
          isLiked: isCurrentlyLiked,
          likes: currentLikeCount,
        );
        notifyListeners();
      }
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
      _reels[index] = currentReel.copyWith(views: currentViews + 1);
      notifyListeners();

      // API call to increment view count (fire and forget)
      final userId = await _getUserId();
      if (userId != null) {
        http
            .post(
              Uri.parse('http://82.29.162.67:4061/api/topics/increment-view'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'userId': userId, 'reelId': reelId}),
            )
            .catchError((e) => debugPrint('View increment error: $e'));
      }

      return true;
    } catch (e) {
      debugPrint('Increment view error: $e');
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
