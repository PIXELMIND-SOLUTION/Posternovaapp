import 'package:flutter/material.dart';

class AutoPlayReelVideo extends StatelessWidget {
  final String thumbnailUrl;

  const AutoPlayReelVideo({super.key, required this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    if (thumbnailUrl.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.play_circle_outline_rounded,
            color: Colors.white38,
            size: 36,
          ),
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: Image.network(
        thumbnailUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.broken_image_rounded,
                color: Colors.white38,
                size: 36,
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white54,
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}
