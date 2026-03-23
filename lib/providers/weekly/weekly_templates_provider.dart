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

  // Getters
  Map<String, List<WeeklyTemplate>> get weeklyPosters => _weeklyPosters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _weeklyPosters.isNotEmpty;

  // Get posters for a specific day
  List<WeeklyTemplate> getPostersForDay(String day) {
    return _weeklyPosters[day] ?? [];
  }

  // Get all available days
  List<String> get availableDays => _weeklyPosters.keys.toList();

  // Fetch weekly posters from API
  Future<bool> fetchWeeklyPosters(
    String userId, {
    bool forceRefresh = false,
  }) async {
    // If we already have data and not forcing refresh, return cached data
    if (!forceRefresh && hasData) {
      print('Using cached weekly posters data');
      return true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/poster/weeklyposters/$userId'),
      );

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

        _weeklyPosters = formattedData;
        _isLoading = false;
        _isInitialized = true;
        notifyListeners();
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
    notifyListeners();
  }

  // Manual refresh
  Future<bool> refresh(String userId) async {
    return await fetchWeeklyPosters(userId, forceRefresh: true);
  }
}
