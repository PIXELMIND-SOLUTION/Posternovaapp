import 'package:flutter/foundation.dart';
import 'package:posternova/models/trending_poster_model.dart';
import 'package:posternova/services/trending/trending_poster_service.dart';

enum TrendingPosterState { idle, loading, loaded, error }

class TrendingPosterProvider extends ChangeNotifier {
  List<TrendingPoster> _posters = [];
  TrendingPosterState _state = TrendingPosterState.idle;
  String _errorMessage = '';

  // Getters
  List<TrendingPoster> get posters => _posters;
  TrendingPosterState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == TrendingPosterState.loading;
  bool get hasError => _state == TrendingPosterState.error;
  bool get hasData => _posters.isNotEmpty;

  /// Fetch all trending posters for a given business ID
  Future<void> fetchTrendingPosters(String businessId) async {
    if (_state == TrendingPosterState.loading) return;

    _setState(TrendingPosterState.loading);
    _errorMessage = '';

    try {
      final posters = await TrendingPosterService.getAllTrendingPosters(businessId);
      _posters = posters;
      _setState(TrendingPosterState.loaded);
    } on TrendingPosterException catch (e) {
      _errorMessage = e.message;
      _setState(TrendingPosterState.error);
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      _setState(TrendingPosterState.error);
    }
  }

  /// Refresh posters (clears existing and re-fetches)
  Future<void> refreshPosters(String businessId) async {
    _posters = [];
    await fetchTrendingPosters(businessId);
  }

  /// Clear all poster data
  void clearPosters() {
    _posters = [];
    _errorMessage = '';
    _setState(TrendingPosterState.idle);
  }

  void _setState(TrendingPosterState newState) {
    _state = newState;
    notifyListeners();
  }
}