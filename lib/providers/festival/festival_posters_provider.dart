// lib/providers/festival/festival_posters_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/festival_poster_model.dart';

class FestivalPostersProvider extends ChangeNotifier {
  List<FestivalPoster> _festivalPosters = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;
  Map<String, List<FestivalPoster>> _cachedPosters = {}; // Cache by date string

  // Getters
  List<FestivalPoster> get festivalPosters => _festivalPosters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _festivalPosters.isNotEmpty;
  DateTime get selectedDate => _selectedDate;

  // Get cached posters for a specific date
  List<FestivalPoster> getCachedPostersForDate(DateTime date) {
    final dateKey = _formatDateKey(date);
    return _cachedPosters[dateKey] ?? [];
  }

  // Check if date has cached data
  bool hasCachedDataForDate(DateTime date) {
    final dateKey = _formatDateKey(date);
    return _cachedPosters.containsKey(dateKey) &&
        _cachedPosters[dateKey]!.isNotEmpty;
  }

  // Format date as key
  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  // Fetch festival posters from API
  Future<bool> fetchFestivalPosters(
    DateTime date, {
    bool forceRefresh = false,
  }) async {
    final dateKey = _formatDateKey(date);

    // If we have cached data for this date and not forcing refresh, return cached data
    if (!forceRefresh && hasCachedDataForDate(date)) {
      print('Using cached festival posters for date: $dateKey');
      _festivalPosters = _cachedPosters[dateKey]!;
      _selectedDate = date;
      notifyListeners();
      return true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://31.97.206.144:4061/api/poster/festival'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'festivalDate': _formatDate(date)}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List postersData = decoded is List ? decoded : [];

        final List<FestivalPoster> posters = postersData
            .map((item) => FestivalPoster.fromJson(item, date))
            .toList();

        // Cache the result
        _cachedPosters[dateKey] = posters;
        _festivalPosters = posters;
        _selectedDate = date;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to load festival posters';
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

  // Change date and fetch posters
  Future<bool> changeDate(DateTime newDate) async {
    if (_selectedDate.year == newDate.year &&
        _selectedDate.month == newDate.month &&
        _selectedDate.day == newDate.day) {
      return true; // Same date, no need to fetch
    }

    return await fetchFestivalPosters(newDate);
  }

  // Clear cache for specific date
  void clearCacheForDate(DateTime date) {
    final dateKey = _formatDateKey(date);
    _cachedPosters.remove(dateKey);
    if (_selectedDate.year == date.year &&
        _selectedDate.month == date.month &&
        _selectedDate.day == date.day) {
      _festivalPosters = [];
      notifyListeners();
    }
  }

  // Clear all cached data
  void clearAllCache() {
    _cachedPosters.clear();
    _festivalPosters = [];
    _error = null;
    notifyListeners();
  }

  // Manual refresh for current date
  Future<bool> refresh() async {
    return await fetchFestivalPosters(_selectedDate, forceRefresh: true);
  }
}
