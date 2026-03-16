// hot_topic_reels_provider.dart

import 'package:flutter/foundation.dart';
import 'package:posternova/models/hot_topic_model.dart';
import 'package:posternova/services/topic/hot_topic_service.dart';

enum ReelsStatus { idle, loading, success, error }

class HotTopicReelsProvider extends ChangeNotifier {
  final HotTopicReelsService _service = HotTopicReelsService();

  ReelsStatus _status = ReelsStatus.idle;
  HotTopicReelsModel? _hotTopicReels;
  String? _errorMessage;

  ReelsStatus get status => _status;
  HotTopicReelsModel? get hotTopicReels => _hotTopicReels;
  List<Reel> get reels => _hotTopicReels?.reels ?? [];
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ReelsStatus.loading;

  Future<void> loadHotTopicReels(String userId) async {
    _status = ReelsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _hotTopicReels = await _service.fetchHotTopicReels(userId);
      _status = ReelsStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ReelsStatus.error;
    }

    notifyListeners();
  }

  void toggleLike(String reelId) {
    if (_hotTopicReels == null) return;

    final updatedReels = _hotTopicReels!.reels.map((reel) {
      if (reel.id == reelId) {
        return reel.copyWith(
          isLiked: !reel.isLiked,
          likeCount: reel.isLiked ? reel.likeCount - 1 : reel.likeCount + 1,
        );
      }
      return reel;
    }).toList();

    _hotTopicReels = HotTopicReelsModel(
      userId: _hotTopicReels!.userId,
      reels: updatedReels,
    );

    notifyListeners();
  }

  void reset() {
    _status = ReelsStatus.idle;
    _hotTopicReels = null;
    _errorMessage = null;
    notifyListeners();
  }
}