import 'package:flutter/material.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/reels_model.dart';
import 'package:posternova/services/reels/reels_service.dart';

class ReelProvider with ChangeNotifier {
  final ReelService _reelService = ReelService();

  List<Reel> _reels = [];
  bool _isLoading = false;
  String? _error;
  String? _userId;

  // Getters
  List<Reel> get reels => _reels;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;

  // Initialize user ID from preferences
  Future<void> initializeUserId() async {
    final userData = await AuthPreferences.getUserData();
    _userId = userData?.user.id;
    notifyListeners();
  }

  // Fetch all reels
  Future<void> fetchAllReels(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _reelService.getAllReels(userId);

      if (response != null) {
        _reels = response.reels;
        _userId = response.userId;
        _error = null;
      } else {
        _error = 'Failed to fetch reels';
        _reels = [];
      }
    } catch (e) {
      _error = 'Error: $e';
      _reels = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Like a reel
  Future<bool> likeReel(String reelId, String userId) async {
    try {
      final response = await _reelService.likeReel(reelId, userId);

      if (response != null) {
        // Update the reel in the local list
        final index = _reels.indexWhere((reel) => reel.id == reelId);
        if (index != -1) {
          _reels[index] = response.reel;
          notifyListeners();
        }
        return true;
      } else {
        _error = 'Failed to like reel';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  // Unlike a reel
  Future<bool> unlikeReel(String reelId, String userId) async {
    try {
      final response = await _reelService.unlikeReel(reelId, userId);

      if (response != null) {
        // Update the reel in the local list
        final index = _reels.indexWhere((reel) => reel.id == reelId);
        if (index != -1) {
          _reels[index] = response.reel;
          notifyListeners();
        }
        return true;
      } else {
        _error = 'Failed to unlike reel';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  // Toggle like status (like if not liked, unlike if liked)
  Future<bool> toggleLike(String reelId, String userId) async {
    final reel = _reels.firstWhere(
      (reel) => reel.id == reelId,
      orElse: () => throw Exception('Reel not found'),
    );

    if (reel.isLiked) {
      return await unlikeReel(reelId, userId);
    } else {
      return await likeReel(reelId, userId);
    }
  }

  // Get a specific reel by ID
  Reel? getReelById(String reelId) {
    try {
      return _reels.firstWhere((reel) => reel.id == reelId);
    } catch (e) {
      return null;
    }
  }

  // Refresh reels
  Future<void> refreshReels(String userId) async {
    await fetchAllReels(userId);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear all data
  void clear() {
    _reels = [];
    _userId = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}