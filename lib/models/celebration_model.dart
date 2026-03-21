class CelebrationConfig {
  final bool enabled;
  final String videoUrl;
  final int durationSeconds;
  final bool loop;

  CelebrationConfig({
    required this.enabled,
    required this.videoUrl,
    required this.durationSeconds,
    required this.loop,
  });

  factory CelebrationConfig.fromJson(Map<String, dynamic> json) {
    return CelebrationConfig(
      enabled: json['enabled'] ?? false,
      videoUrl: json['video_url'] ?? '',
      durationSeconds: json['duration_seconds'] ?? 10,
      loop: json['loop'] ?? false,
    );
  }
}
