import 'package:flutter/material.dart';
import 'package:posternova/views/reels/exo_video_player.dart';

class AutoPlayReelVideo extends StatefulWidget {
  final String videoUrl;
  const AutoPlayReelVideo({required this.videoUrl});

  @override
  State<AutoPlayReelVideo> createState() => _AutoPlayReelVideoState();
}

class _AutoPlayReelVideoState extends State<AutoPlayReelVideo> {
  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl.isEmpty) {
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

    // Add GestureDetector to the container that wraps ExoVideoPlayer
    return Container(
      color: Colors.black,
      child: ExoVideoPlayer(url: widget.videoUrl, autoPlay: false),
    );
  }
}
