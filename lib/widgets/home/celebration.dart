// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// enum MediaType { video, gif }

// class CelebrationConfig {
//   final bool enabled;
//   final String mediaUrl; // renamed from videoUrl
//   final MediaType mediaType;
//   final int durationSeconds;
//   final bool loop;

//   // ── Theme fields (all optional — null = use app defaults) ──────────────────
//   final List<Color>? gradientColors;
//   final Color? sectionBgColor;
//   final Color? primaryTextColor;
//   final Color? secondaryTextColor;
//   final Color? accentColor;

//   CelebrationConfig({
//     required this.enabled,
//     required this.mediaUrl,
//     required this.mediaType,
//     required this.durationSeconds,
//     required this.loop,
//     this.gradientColors,
//     this.sectionBgColor,
//     this.primaryTextColor,
//     this.secondaryTextColor,
//     this.accentColor,
//   });

//   /// Parse a hex string like "#FF6B6B" or "FF6B6B" → Color
//   static Color? _hexToColor(String? hex) {
//     if (hex == null || hex.isEmpty) return null;
//     final cleaned = hex.replaceAll('#', '');
//     if (cleaned.length == 6) {
//       return Color(int.parse('FF$cleaned', radix: 16));
//     } else if (cleaned.length == 8) {
//       return Color(int.parse(cleaned, radix: 16));
//     }
//     return null;
//   }

//   factory CelebrationConfig.fromJson(Map<String, dynamic> json) {
//     List<Color>? gradients;
//     final url = json['video_url'] ?? '';
//     final isGif = url.toLowerCase().endsWith('.gif');

//     final rawGradients = json['gradient_colors'];

//     if (rawGradients is List && rawGradients.isNotEmpty) {
//       List<String> gradientStrings = [];

//       // Case 1: Correct format
//       if (rawGradients.first is String &&
//           !rawGradients.first.toString().startsWith('[')) {
//         gradientStrings = rawGradients.cast<String>();
//       }
//       // Case 2: Wrong format with nested JSON string
//       else if (rawGradients.first is String &&
//           rawGradients.first.toString().startsWith('[')) {
//         try {
//           final decoded = jsonDecode(rawGradients.first);
//           if (decoded is List) {
//             gradientStrings = decoded.cast<String>();
//           }
//         } catch (_) {}
//       }

//       final parsed = gradientStrings
//           .map((e) => _hexToColor(e))
//           .whereType<Color>()
//           .toList();

//       if (parsed.length >= 2) gradients = parsed;
//     }

//     return CelebrationConfig(
//       enabled: json['enabled'] ?? false,
//       mediaUrl: url,
//       mediaType: isGif ? MediaType.gif : MediaType.video,
//       durationSeconds: json['duration_seconds'] ?? 10,
//       loop: json['loop'] ?? false,
//       gradientColors: gradients,
//       sectionBgColor: _hexToColor(json['section_bg_color']),
//       primaryTextColor: _hexToColor(json['primary_text_color']),
//       secondaryTextColor: _hexToColor(json['secondary_text_color']),
//       accentColor: _hexToColor(json['accent_color']),
//     );
//   }

//   /// True if any theming field is present
//   bool get hasTheme =>
//       gradientColors != null ||
//       sectionBgColor != null ||
//       primaryTextColor != null ||
//       secondaryTextColor != null ||
//       accentColor != null;
// }
