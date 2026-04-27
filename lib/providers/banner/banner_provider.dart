// lib/providers/banner/banner_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/banner_model.dart';

class BannerProvider extends ChangeNotifier {
  List<BannerModel> _banners = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Getters
  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _banners.isNotEmpty;
  int get bannerCount => _banners.length;

  // Fetch banners from API
  Future<bool> fetchBanners({bool forceRefresh = false}) async {
    // If we already have data and not forcing refresh, return cached data
    if (!forceRefresh && hasData) {
      print('Using cached banners data');
      return true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://31.97.228.17:4061/api/poster/getbanners'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle different response formats
        List bannersData = [];
        if (data is List) {
          bannersData = data;
        } else if (data['banners'] is List) {
          bannersData = data['banners'];
        } else if (data['data'] is List) {
          bannersData = data['data'];
        }

        _banners = bannersData
            .map((item) => BannerModel.fromJson(item))
            .where(
              (banner) => banner.imageUrl.isNotEmpty,
            ) // Filter out banners without images
            .toList();

        // Sort by order if available
        _banners.sort((a, b) => a.order.compareTo(b.order));

        _isLoading = false;
        _isInitialized = true;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to load banners';
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

  // Get banner by index
  BannerModel? getBannerByIndex(int index) {
    if (index >= 0 && index < _banners.length) {
      return _banners[index];
    }
    return null;
  }

  // Clear data (useful for logout)
  void clearData() {
    _banners = [];
    _isInitialized = false;
    _error = null;
    notifyListeners();
  }

  // Manual refresh
  Future<bool> refresh() async {
    return await fetchBanners(forceRefresh: true);
  }
}
