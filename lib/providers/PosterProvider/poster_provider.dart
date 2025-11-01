
import 'package:flutter/material.dart';
import 'package:posternova/models/poster_model.dart';
import 'package:posternova/services/PosterServices/poster_service.dart';


class CanvaPosterProvider extends ChangeNotifier {
  final NewCanvasPosterService _posterService = NewCanvasPosterService();

  List<CanvasPosterModel> _posters = [];
  bool _isLoading = false;
  String? _error;

  List<CanvasPosterModel> get posters => _posters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Group posters by category
  Map<String, List<CanvasPosterModel>> get postersByCategory {
    Map<String, List<CanvasPosterModel>> grouped = {};
    for (var poster in _posters) {
      if (grouped.containsKey(poster.categoryName)) {
        grouped[poster.categoryName]!.add(poster);
      } else {
        grouped[poster.categoryName] = [poster];
      }
    }
    return grouped;
  }

  // Get all unique categories
  List<String> get categories {
    return _posters.map((poster) => poster.categoryName).toSet().toList();
  }

  // Get posters by specific category
  List<CanvasPosterModel> getPostersByCategory(String categoryName) {
    return _posters.where((poster) => poster.categoryName == categoryName).toList();
  }

  // Get limited posters per category (for home screen preview)
  Map<String, List<CanvasPosterModel>> getGroupedPostersWithLimit({int limit = 5}) {
    Map<String, List<CanvasPosterModel>> grouped = {};
    for (var poster in _posters) {
      if (grouped.containsKey(poster.categoryName)) {
        if (grouped[poster.categoryName]!.length < limit) {
          grouped[poster.categoryName]!.add(poster);
        }
      } else {
        grouped[poster.categoryName] = [poster];
      }
    }
    return grouped;
  }

  Future<void> fetchPosters() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Fetching canvas posters...');
      _posters = await _posterService.fetchCanvasPosters();
      print('Successfully fetched ${_posters.length} posters');
      print('Categories found: ${categories.join(', ')}');
    } catch (e) {
      print('Error fetching posters: ${e.toString()}');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear data
  void clearData() {
    _posters.clear();
    _error = null;
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await fetchPosters();
  }
}