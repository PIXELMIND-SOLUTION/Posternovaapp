// ─────────────────────────────────────────────────────────────────────────────
// AUTO PLAY REEL VIDEO
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AutoPlayReelVideo extends StatefulWidget {
  final String videoUrl;
  const AutoPlayReelVideo({required this.videoUrl});

  @override
  State<AutoPlayReelVideo> createState() => _AutoPlayReelVideoState();
}

class _AutoPlayReelVideoState extends State<AutoPlayReelVideo> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    if (widget.videoUrl.isEmpty) {
      setState(() => _hasError = true);
      return;
    }
    try {
      // Check if it's an asset or network URL
      if (widget.videoUrl.startsWith('assets/')) {
        _controller = VideoPlayerController.asset(widget.videoUrl);
      } else {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
        );
      }

      await _controller!.initialize();
      if (!mounted) return;

      _controller!
        ..setLooping(true)
        ..setVolume(0)
        ..play();

      print("Video playing: ${_controller!.value.isPlaying}"); // Debug log
      setState(() => _initialized = true);
    } catch (e) {
      print("Video error: $e");
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // REMOVED the extra @override here - this was the syntax error!
  Widget build(BuildContext context) {
    if (_hasError || !_initialized || _controller == null) {
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

    // Fix: Use FittedBox to ensure video fills the container properly
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: VideoPlayer(_controller!),
      ),
    );
  }
}
