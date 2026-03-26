// lib/providers/weekly/weekly_templates_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/weekly_template_model.dart';

class WeeklyTemplatesProvider extends ChangeNotifier {
  Map<String, List<WeeklyTemplate>> _weeklyPosters = {};
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Add cache with timestamp to avoid frequent refreshes
  Map<String, CacheData> _cache = {};
  static const Duration _cacheDuration = Duration(minutes: 30);

  // Getters
  Map<String, List<WeeklyTemplate>> get weeklyPosters => _weeklyPosters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _weeklyPosters.isNotEmpty;
  bool get isInitialized => _isInitialized;

  // Get posters for a specific day
  List<WeeklyTemplate> getPostersForDay(String day) {
    return _weeklyPosters[day] ?? [];
  }

  // Get all available days
  List<String> get availableDays => _weeklyPosters.keys.toList();

  // Initialize provider (call once)
  Future<bool> initialize(String userId) async {
    if (_isInitialized && _weeklyPosters.isNotEmpty) {
      print('Weekly templates already initialized');
      return true;
    }
    return await fetchWeeklyPosters(userId);
  }

  // Fetch weekly posters from API with caching
  Future<bool> fetchWeeklyPosters(
    String userId, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'weekly_$userId';
    print("haggagagagagaagagagagagaga");
    // // Check cache if not forcing refresh
    // if (!forceRefresh && _cache.containsKey(cacheKey)) {
    //   final cached = _cache[cacheKey]!;
    //   if (DateTime.now().difference(cached.timestamp) < _cacheDuration) {
    //     print('✅ Using cached weekly posters data');
    //     _weeklyPosters = cached.data;
    //     _isLoading = false;
    //     _isInitialized = true;
    //     notifyListeners();
    //     return true;
    //   } else {
    //     // Cache expired, remove it
    //     _cache.remove(cacheKey);
    //   }
    // }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🌐 Fetching weekly posters from API for user: $userId');
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/poster/weeklyposters/$userId'),
      );

      print('📡 Weekly posters API Status: ${response.statusCode}');
      print('📡 Weekly posters API Status: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, List<WeeklyTemplate>> formattedData = {};

        data.forEach((day, posters) {
          if (posters is List && posters.isNotEmpty) {
            formattedData[day] = posters
                .map((poster) => WeeklyTemplate.fromJson(poster, day))
                .toList();
          }
        });

        // Update data and cache
        _weeklyPosters = formattedData;
        _cache[cacheKey] = CacheData(
          data: formattedData,
          timestamp: DateTime.now(),
        );
        _isLoading = false;
        _isInitialized = true;
        notifyListeners();

        print('✅ Loaded ${formattedData.length} days of weekly posters');
        return true;
      } else {
        _error = 'Failed to load weekly templates';
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

  // Clear data (useful for logout)
  void clearData() {
    _weeklyPosters = {};
    _isInitialized = false;
    _error = null;
    _cache.clear();
    notifyListeners();
  }

  // Manual refresh
  Future<bool> refresh(String userId) async {
    return await fetchWeeklyPosters(userId, forceRefresh: true);
  }
}

// Cache helper class
class CacheData {
  final Map<String, List<WeeklyTemplate>> data;
  final DateTime timestamp;

  CacheData({required this.data, required this.timestamp});
}
