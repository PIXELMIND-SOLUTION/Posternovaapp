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
  Map<String, List<FestivalPoster>> _cachedPosters = {};

  // Track if initial load is done
  bool _initialLoadDone = false;

  // Getters
  List<FestivalPoster> get festivalPosters => _festivalPosters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _festivalPosters.isNotEmpty;
  DateTime get selectedDate => _selectedDate;

  bool hasCachedDataForDate(DateTime date) {
    final dateKey = _formatDateKey(date);
    return _cachedPosters.containsKey(dateKey);
  }

  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  // Initialize with current date
  Future<void> initialize(DateTime date) async {
    if (!_initialLoadDone) {
      await fetchFestivalPosters(date);
      _initialLoadDone = true;
    }
  }

  // Change date and fetch posters
  Future<bool> changeDate(DateTime newDate) async {
    final normalizedNewDate = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
    );
    final normalizedCurrentDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    if (normalizedNewDate == normalizedCurrentDate) {
      return true;
    }

    return await fetchFestivalPosters(normalizedNewDate, forceRefresh: true);
  }

  // Fetch festival posters from API
  // In festival_posters_provider.dart
  Future<bool> fetchFestivalPosters(
    DateTime date, {
    bool forceRefresh = false,
  }) async {
    final dateKey = _formatDateKey(date);

    // If we have cached data for this date and not forcing refresh, return cached data
    if (!forceRefresh && hasCachedDataForDate(date)) {
      print('✅ Using cached data for date: $dateKey');
      _festivalPosters = _cachedPosters[dateKey]!;
      _selectedDate = date;
      _isLoading = false;
      notifyListeners(); // Make sure to notify even when using cache
      return true;
    }

    _isLoading = true;
    _error = null;
    // Clear old data immediately to show loading state
    _festivalPosters = [];
    _selectedDate = date;
    notifyListeners(); // Notify immediately to clear old data

    try {
      final formattedDate = _formatDate(date);
      print('🌐 Making API request for date: $formattedDate');

      final response = await http
          .post(
            Uri.parse('http://31.97.206.144:4061/api/poster/festival'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'festivalDate': formattedDate}),
          )
          .timeout(const Duration(seconds: 10));

      print('📡 API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List postersData = decoded is List ? decoded : [];

        print('📊 Found ${postersData.length} posters in response');

        final List<FestivalPoster> posters = postersData
            .map((item) => FestivalPoster.fromJson(item, date))
            .toList();

        // Cache the result (even if empty)
        _cachedPosters[dateKey] = posters;
        _festivalPosters = posters;
        _selectedDate = date;
        _isLoading = false;
        notifyListeners(); // Notify after data is loaded
        return true;
      } else {
        _error = 'Failed to load festival posters';
        _festivalPosters = [];
        _selectedDate = date;
        _isLoading = false;
        notifyListeners(); // Notify even on error
        return false;
      }
    } catch (e) {
      _error = 'Error: $e';
      _festivalPosters = [];
      _selectedDate = date;
      _isLoading = false;
      notifyListeners(); // Notify even on exception
      return false;
    }
  }

  Future<bool> refresh() async {
    return await fetchFestivalPosters(_selectedDate, forceRefresh: true);
  }

  void clearAllCache() {
    _cachedPosters.clear();
    _festivalPosters = [];
    _error = null;
    notifyListeners();
  }
}
