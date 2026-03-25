import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CelebrationVideoWidget extends StatefulWidget {
  final VideoPlayerController controller;
  const CelebrationVideoWidget({required this.controller});

  @override
  State<CelebrationVideoWidget> createState() => _CelebrationVideoWidgetState();
}

class _CelebrationVideoWidgetState extends State<CelebrationVideoWidget> {
  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: VideoPlayer(widget.controller),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CELEBRATION CONFIG MODEL
// ─────────────────────────────────────────────────────────────────────────────

class CelebrationConfig {
  final bool enabled;
  final String videoUrl;
  final int durationSeconds;
  final bool loop;

  // ── Theme fields (all optional — null = use app defaults) ──────────────────
  final List<Color>?
  gradientColors; // e.g. [Color(0xFFFF6B6B), Color(0xFF4ECDC4)]
  final Color? sectionBgColor; // background of each section card
  final Color? primaryTextColor; // section titles, day labels
  final Color? secondaryTextColor; // subtitles, "View All", grey text
  final Color? accentColor; // selected date chip, dots, highlights

  CelebrationConfig({
    required this.enabled,
    required this.videoUrl,
    required this.durationSeconds,
    required this.loop,
    this.gradientColors,
    this.sectionBgColor,
    this.primaryTextColor,
    this.secondaryTextColor,
    this.accentColor,
  });

  /// Parse a hex string like "#FF6B6B" or "FF6B6B" → Color
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
    // gradient_colors: ["#FF6B6B", "#4ECDC4"] or null
    List<Color>? gradients;
    final rawGradients = json['gradient_colors'];
    if (rawGradients is List && rawGradients.isNotEmpty) {
      final parsed = rawGradients
          .map((e) => _hexToColor(e?.toString()))
          .whereType<Color>()
          .toList();
      if (parsed.length >= 2) gradients = parsed;
    }

    return CelebrationConfig(
      enabled: json['enabled'] ?? false,
      videoUrl: json['video_url'] ?? '',
      durationSeconds: json['duration_seconds'] ?? 10,
      loop: json['loop'] ?? false,
      gradientColors: gradients,
      sectionBgColor: _hexToColor(json['section_bg_color']),
      primaryTextColor: _hexToColor(json['primary_text_color']),
      secondaryTextColor: _hexToColor(json['secondary_text_color']),
      accentColor: _hexToColor(json['accent_color']),
    );
  }

  /// True if any theming field is present
  bool get hasTheme =>
      gradientColors != null ||
      sectionBgColor != null ||
      primaryTextColor != null ||
      secondaryTextColor != null ||
      accentColor != null;
}
