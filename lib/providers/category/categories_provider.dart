// lib/providers/categories/categories_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/models/category_model_home.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoryPoster> _allPosters = [];
  Map<String, List<CategoryPoster>> _categoryMap = {};
  List<String> _uniqueCategories = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Getters
  List<CategoryPoster> get allPosters => _allPosters;
  Map<String, List<CategoryPoster>> get categoryMap => _categoryMap;
  List<String> get uniqueCategories => _uniqueCategories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _allPosters.isNotEmpty;
  int get totalPosters => _allPosters.length;
  int get totalCategories => _uniqueCategories.length;

  // Get posters by category
  List<CategoryPoster> getPostersByCategory(String category) {
    return _categoryMap[category] ?? [];
  }

  // Get category name by index
  String? getCategoryByIndex(int index) {
    if (index >= 0 && index < _uniqueCategories.length) {
      return _uniqueCategories[index];
    }
    return null;
  }

  // Fetch all category posters from API
  Future<bool> fetchCategories({bool forceRefresh = false}) async {
    // If we already have data and not forcing refresh, return cached data
    if (!forceRefresh && hasData) {
      print('Using cached categories data');
      return true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/poster/getallposters'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle different response formats
        List postersData = [];
        if (data is List) {
          postersData = data;
        } else if (data['posters'] is List) {
          postersData = data['posters'];
        } else if (data['data'] is List) {
          postersData = data['data'];
        }

        // Parse all posters
        _allPosters = postersData
            .map((item) => CategoryPoster.fromJson(item))
            .where((poster) => poster.imageUrl.isNotEmpty)
            .toList();

        // Group by category
        _categoryMap = {};
        for (var poster in _allPosters) {
          final category = poster.categoryName;
          if (category.isNotEmpty) {
            if (!_categoryMap.containsKey(category)) {
              _categoryMap[category] = [];
            }
            _categoryMap[category]!.add(poster);
          }
        }

        // Get unique categories and sort them
        _uniqueCategories = _categoryMap.keys.toList();
        _uniqueCategories.sort();

        _isLoading = false;
        _isInitialized = true;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to load categories';
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

  // Search posters by keyword
  List<CategoryPoster> searchPosters(String keyword) {
    if (keyword.isEmpty) return [];

    final lowerKeyword = keyword.toLowerCase();
    return _allPosters.where((poster) {
      return poster.categoryName.toLowerCase().contains(lowerKeyword) ||
          (poster.title?.toLowerCase().contains(lowerKeyword) ?? false);
    }).toList();
  }

  // Get posters by category with limit
  List<CategoryPoster> getPostersByCategoryWithLimit(
    String category,
    int limit,
  ) {
    final posters = getPostersByCategory(category);
    if (posters.length <= limit) return posters;
    return posters.sublist(0, limit);
  }

  // Check if category has posters
  bool categoryHasPosters(String category) {
    return _categoryMap.containsKey(category) &&
        _categoryMap[category]!.isNotEmpty;
  }

  // Get category poster count
  int getCategoryPosterCount(String category) {
    return _categoryMap[category]?.length ?? 0;
  }

  // Get random posters from category
  List<CategoryPoster> getRandomPostersFromCategory(
    String category,
    int count,
  ) {
    final posters = getPostersByCategory(category);
    if (posters.isEmpty) return [];

    if (posters.length <= count) return posters;

    final shuffled = List<CategoryPoster>.from(posters);
    shuffled.shuffle();
    return shuffled.take(count).toList();
  }

  // Clear all data
  void clearData() {
    _allPosters = [];
    _categoryMap = {};
    _uniqueCategories = [];
    _isInitialized = false;
    _error = null;
    notifyListeners();
  }

  // Manual refresh
  Future<bool> refresh() async {
    return await fetchCategories(forceRefresh: true);
  }
}
