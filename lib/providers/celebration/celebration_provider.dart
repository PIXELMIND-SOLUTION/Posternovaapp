import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum MediaType { video, gif }

class CelebrationConfig {
  final bool enabled;
  final String mediaUrl;
  final MediaType mediaType;
  final int durationSeconds;
  final bool loop;
  final List<Color>? gradientColors;
  final Color? sectionBgColor;
  final Color? primaryTextColor;
  final Color? secondaryTextColor;
  final Color? accentColor;

  CelebrationConfig({
    required this.enabled,
    required this.mediaUrl,
    required this.mediaType,
    required this.durationSeconds,
    required this.loop,
    this.gradientColors,
    this.sectionBgColor,
    this.primaryTextColor,
    this.secondaryTextColor,
    this.accentColor,
  });

  static Color? _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    } else if (cleaned.length == 8) {
      return Color(int.parse(cleaned, radix: 16));
    }
    return null;
  }

  factory CelebrationConfig.fromJson(Map<String, dynamic> json) {
    List<Color>? gradients;
    final url = json['video_url'] ?? '';
    final isGif = url.toLowerCase().endsWith('.gif');

    final rawGradients = json['gradient_colors'];

    if (rawGradients is List && rawGradients.isNotEmpty) {
      List<String> gradientStrings = [];

      if (rawGradients.first is String &&
          !rawGradients.first.toString().startsWith('[')) {
        gradientStrings = rawGradients.cast<String>();
      } else if (rawGradients.first is String &&
          rawGradients.first.toString().startsWith('[')) {
        try {
          final decoded = jsonDecode(rawGradients.first);
          if (decoded is List) {
            gradientStrings = decoded.cast<String>();
          }
        } catch (_) {}
      }

      final parsed = gradientStrings
          .map((e) => _hexToColor(e))
          .whereType<Color>()
          .toList();

      if (parsed.length >= 2) gradients = parsed;
    }

    return CelebrationConfig(
      enabled: json['enabled'] ?? false,
      mediaUrl: url,
      mediaType: isGif ? MediaType.gif : MediaType.video,
      durationSeconds: json['duration_seconds'] ?? 10,
      loop: json['loop'] ?? false,
      gradientColors: gradients,
      sectionBgColor: _hexToColor(json['section_bg_color']),
      primaryTextColor: _hexToColor(json['primary_text_color']),
      secondaryTextColor: _hexToColor(json['secondary_text_color']),
      accentColor: _hexToColor(json['accent_color']),
    );
  }

  bool get hasTheme =>
      gradientColors != null ||
      sectionBgColor != null ||
      primaryTextColor != null ||
      secondaryTextColor != null ||
      accentColor != null;
}

class CelebrationProvider extends ChangeNotifier {
  CelebrationConfig? _celebrationConfig;
  bool _isLoading = false;
  String? _error;
  bool _hasLoaded = false;

  CelebrationConfig? get celebrationConfig => _celebrationConfig;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLoaded => _hasLoaded;
  bool get isEnabled => _celebrationConfig?.enabled ?? false;
  bool get hasTheme => _celebrationConfig?.hasTheme ?? false;

  // Theme getters with defaults
  Color get primaryTextColor =>
      _celebrationConfig?.primaryTextColor ?? const Color(0xFF1A1A1A);
  Color get secondaryTextColor =>
      _celebrationConfig?.secondaryTextColor ?? Colors.grey;
  Color get sectionBgColor =>
      _celebrationConfig?.sectionBgColor ?? Colors.white;
  Color get accentColor =>
      _celebrationConfig?.accentColor ?? const Color(0xFFFFC107);
  List<Color>? get gradientColors => _celebrationConfig?.gradientColors;
  bool get hasMedia =>
      _celebrationConfig != null &&
      _celebrationConfig!.enabled &&
      _celebrationConfig!.mediaUrl.isNotEmpty;

  Future<void> fetchCelebrationConfig({bool forceRefresh = false}) async {
    // Don't fetch if already loaded and not forcing refresh
    if (_hasLoaded && !forceRefresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://82.29.162.67:4061/api/admin/getactivecelebration'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _celebrationConfig = CelebrationConfig.fromJson(data);
        _hasLoaded = true;
        _error = null;
      } else {
        _error = 'Failed to load celebration config';
        _celebrationConfig = null;
      }
    } catch (e) {
      _error = 'Error: $e';
      _celebrationConfig = null;
      debugPrint('fetchCelebration: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _celebrationConfig = null;
    _isLoading = false;
    _error = null;
    _hasLoaded = false;
    notifyListeners();
  }
}
