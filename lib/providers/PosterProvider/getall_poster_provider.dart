import 'package:flutter/material.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/services/PosterServices/getall_poster_service.dart';

class PosterProvider extends ChangeNotifier {
  final PosterService _service = PosterService();

  List<CategoryModel> _posters = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get posters => _posters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> getAvailableLanguages() {
    final languages = <String>{};
    for (var poster in _posters) {
      if (poster.posterlang.isNotEmpty) {
        languages.add(poster.posterlang);
      }
    }
    return languages.toList();
  }

  List<CategoryModel> getPostersByLanguage(String? language) {
    if (language == null || language == 'all') {
      return _posters;
    }
    return _posters
        .where(
          (poster) => poster.posterlang.toLowerCase() == language.toLowerCase(),
        )
        .toList();
  }

  /// Fetch posters using userId from stored user data
  Future<void> fetchPosters() async {
    print('PosterProvider: Starting fetchPosters');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get userId from stored user data
      final userData = await AuthPreferences.getUserData();

      if (userData == null || userData.user.id == null) {
        throw 'User not logged in';
      }

      final userId = userData.user.id!;
      print('PosterProvider: Fetching posters for userId: $userId');

      _posters = await _service.fetchTemplates(userId);
      print('PosterProvider: Fetched ${_posters.length} posters');

      // Debug: Print first poster if available
      if (_posters.isNotEmpty) {
        print(
          'First poster: ${_posters[0].name}, Category: ${_posters[0].categoryName}',
        );
      } else {
        print('No posters fetched from service');
      }
    } catch (e) {
      print('PosterProvider Error: $e');
      _error = 'Failed to load posters: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch posters with explicit userId parameter (optional alternative method)
  Future<void> fetchPostersWithUserId(String userId) async {
    print('PosterProvider: Starting fetchPostersWithUserId for: $userId');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('PosterProvider: Calling service.fetchTemplates()');
      _posters = await _service.fetchTemplates(userId);
      print('PosterProvider: Fetched ${_posters.length} posters');

      if (_posters.isNotEmpty) {
        print(
          'First poster: ${_posters[0].name}, Category: ${_posters[0].categoryName}',
        );
      } else {
        print('No posters fetched from service');
      }
    } catch (e) {
      print('PosterProvider Error: $e');
      _error = 'Failed to load posters: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }





  Map<String, List<CategoryModel>> _weeklyTemplates = {};
bool _isWeeklyLoading = false;
String? _weeklyError;

Map<String, List<CategoryModel>> get weeklyTemplates => _weeklyTemplates;
bool get isWeeklyLoading => _isWeeklyLoading;
String? get weeklyError => _weeklyError;

/// All weekly posters flattened into a single list (useful for language filtering)
List<CategoryModel> get allWeeklyPosters =>
    _weeklyTemplates.values.expand((list) => list).toList();

/// Fetch weekly templates using userId from stored user data
Future<void> fetchWeeklyTemplates() async {
  print('PosterProvider: Starting fetchWeeklyTemplates');
  _isWeeklyLoading = true;
  _weeklyError = null;
  notifyListeners();

  try {
    final userData = await AuthPreferences.getUserData();

    if (userData == null || userData.user.id == null) {
      throw 'User not logged in';
    }

    final userId = userData.user.id!;
    print('PosterProvider: Fetching weekly templates for userId: $userId');

    _weeklyTemplates = await _service.fetchWeeklyTemplates(userId);
    print('PosterProvider: Fetched ${_weeklyTemplates.length} weekly categories');
  } catch (e) {
    print('PosterProvider Weekly Error: $e');
    _weeklyError = 'Failed to load weekly templates: $e';
  } finally {
    _isWeeklyLoading = false;
    notifyListeners();
  }
}



void clearWeeklyTemplates() {
  _weeklyTemplates = {};
  _weeklyError = null;
  _isWeeklyLoading = false;
  notifyListeners();
}


  /// Clear posters and reset state
  void clearPosters() {
    _posters = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
