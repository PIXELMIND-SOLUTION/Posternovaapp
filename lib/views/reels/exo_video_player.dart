// import 'dart:io'; // ✅ IMPORTANT
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart'; // ✅ for iOS

// class ExoVideoPlayer extends StatefulWidget {
//   final String url;
//   final bool autoPlay;

//   const ExoVideoPlayer({Key? key, required this.url, this.autoPlay = true})
//     : super(key: key);

//   @override
//   State<ExoVideoPlayer> createState() => _ExoVideoPlayerState();
// }

// class _ExoVideoPlayerState extends State<ExoVideoPlayer> {
//   // ANDROID
//   MethodChannel? _channel;
//   bool _isViewReady = false;

//   // IOS
//   VideoPlayerController? _iosController;
//   bool _iosInitialized = false;

//   @override
//   void initState() {
//     super.initState();

//     // ✅ iOS initialization
//     if (Platform.isIOS) {
//       _initIOSPlayer();
//     }
//   }

//   // ================= IOS PLAYER =================

//   Future<void> _initIOSPlayer() async {
//     _iosController = VideoPlayerController.network(widget.url);

//     try {
//       await _iosController!.initialize();
//       _iosInitialized = true;

//       if (widget.autoPlay) {
//         _iosController!.play();
//       }

//       setState(() {});
//     } catch (e) {
//       debugPrint("iOS video error: $e");
//     }
//   }

//   void _updateIOSPlayback() {
//     if (_iosController == null) return;

//     if (widget.autoPlay) {
//       _iosController!.play();
//     } else {
//       _iosController!.pause();
//     }
//   }

//   void _loadNewIOSVideo() async {
//     await _iosController?.dispose();

//     _iosInitialized = false;

//     _iosController = VideoPlayerController.network(widget.url);

//     await _iosController!.initialize();
//     _iosInitialized = true;

//     if (widget.autoPlay) {
//       _iosController!.play();
//     }

//     setState(() {});
//   }

//   // ================= ANDROID PLAYER =================

//   void _updatePlaybackState() {
//     if (widget.autoPlay) {
//       _channel?.invokeMethod('play');
//     } else {
//       _channel?.invokeMethod('pause');
//     }
//   }

//   void _loadNewVideo() {
//     if (_channel != null) {
//       final Map<String, dynamic> params = {
//         'url': widget.url,
//         'autoPlay': widget.autoPlay,
//       };
//       _channel?.invokeMethod('loadVideo', params);
//     }
//   }

//   // ================= COMMON =================

//   @override
//   void didUpdateWidget(ExoVideoPlayer oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (Platform.isAndroid) {
//       if (_isViewReady) {
//         if (oldWidget.autoPlay != widget.autoPlay) {
//           _updatePlaybackState();
//         }
//         if (oldWidget.url != widget.url) {
//           _loadNewVideo();
//         }
//       }
//     } else if (Platform.isIOS) {
//       if (oldWidget.autoPlay != widget.autoPlay) {
//         _updateIOSPlayback();
//       }
//       if (oldWidget.url != widget.url) {
//         _loadNewIOSVideo();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _channel = null;
//     _iosController?.dispose(); // ✅ important
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ================= ANDROID =================
//     if (Platform.isAndroid) {
//       const String viewType = 'com.posternova/ExoPlayerView';

//       final Map<String, dynamic> creationParams = {
//         'url': widget.url,
//         'autoPlay': widget.autoPlay,
//       };

//       return PlatformViewLink(
//         viewType: viewType,
//         surfaceFactory: (context, controller) {
//           return AndroidViewSurface(
//             controller: controller as AndroidViewController,
//             gestureRecognizers: const {},
//             hitTestBehavior: PlatformViewHitTestBehavior.opaque,
//           );
//         },
//         onCreatePlatformView: (params) {
//           _channel = MethodChannel('com.posternova/ExoPlayerView_${params.id}');

//           return PlatformViewsService.initSurfaceAndroidView(
//               id: params.id,
//               viewType: viewType,
//               layoutDirection: TextDirection.ltr,
//               creationParams: creationParams,
//               creationParamsCodec: const StandardMessageCodec(),
//               onFocus: () => params.onFocusChanged(true),
//             )
//             ..addOnPlatformViewCreatedListener((id) {
//               params.onPlatformViewCreated(id);
//               setState(() => _isViewReady = true);

//               if (widget.autoPlay) {
//                 _channel?.invokeMethod('play');
//               } else {
//                 _channel?.invokeMethod('pause');
//               }
//             })
//             ..create();
//         },
//       );
//     }

//     // ================= IOS =================
//     if (Platform.isIOS) {
//       if (_iosController == null || !_iosInitialized) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       return FittedBox(
//         fit: BoxFit.cover,
//         child: SizedBox(
//           width: _iosController!.value.size.width,
//           height: _iosController!.value.size.height,
//           child: VideoPlayer(_iosController!),
//         ),
//       );
//     }

//     // ================= FALLBACK =================
//     return const SizedBox();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ExoVideoPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;

  const ExoVideoPlayer({Key? key, required this.url, this.autoPlay = true})
    : super(key: key);

  @override
  State<ExoVideoPlayer> createState() => _ExoVideoPlayerState();
}

class _ExoVideoPlayerState extends State<ExoVideoPlayer>
    with WidgetsBindingObserver {
  // ANDROID
  MethodChannel? _channel;
  bool _isViewReady = false;

  // IOS
  VideoPlayerController? _iosController;
  bool _iosInitialized = false;

  // Track app lifecycle
  bool _isAppPaused = false;

  @override
  void initState() {
    super.initState();

    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // iOS initialization
    if (Platform.isIOS) {
      _initIOSPlayer();
    }
  }

  // ================= LIFECYCLE MANAGEMENT =================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // App is minimized, hidden, or in background
        _isAppPaused = true;
        _pauseVideo();
        break;

      case AppLifecycleState.resumed:
        // App is back in foreground
        _isAppPaused = false;
        if (widget.autoPlay) {
          _resumeVideo();
        }
        break;

      case AppLifecycleState.detached:
        // App is about to be destroyed
        _isAppPaused = true;
        _pauseVideo();
        break;
    }
  }

  void _pauseVideo() {
    if (Platform.isAndroid) {
      _channel?.invokeMethod('pause');
    } else if (Platform.isIOS &&
        _iosController != null &&
        _iosController!.value.isPlaying) {
      _iosController!.pause();
    }
  }

  void _resumeVideo() {
    if (!_isAppPaused) {
      if (Platform.isAndroid) {
        _channel?.invokeMethod('play');
      } else if (Platform.isIOS && _iosController != null && _iosInitialized) {
        _iosController!.play();
      }
    }
  }

  // ================= IOS PLAYER =================

  Future<void> _initIOSPlayer() async {
    _iosController = VideoPlayerController.network(widget.url);

    try {
      await _iosController!.initialize();
      _iosInitialized = true;

      // Only auto-play if app is not paused
      if (widget.autoPlay && !_isAppPaused) {
        _iosController!.play();
      }

      setState(() {});
    } catch (e) {
      debugPrint("iOS video error: $e");
    }
  }

  void _updateIOSPlayback() {
    if (_iosController == null || _isAppPaused) return;

    if (widget.autoPlay) {
      _iosController!.play();
    } else {
      _iosController!.pause();
    }
  }

  void _loadNewIOSVideo() async {
    await _iosController?.dispose();

    _iosInitialized = false;

    _iosController = VideoPlayerController.network(widget.url);

    await _iosController!.initialize();
    _iosInitialized = true;

    if (widget.autoPlay && !_isAppPaused) {
      _iosController!.play();
    }

    setState(() {});
  }

  // ================= ANDROID PLAYER =================

  void _updatePlaybackState() {
    if (_isAppPaused) return;

    if (widget.autoPlay) {
      _channel?.invokeMethod('play');
    } else {
      _channel?.invokeMethod('pause');
    }
  }

  void _loadNewVideo() {
    if (_channel != null) {
      final Map<String, dynamic> params = {
        'url': widget.url,
        'autoPlay': widget.autoPlay && !_isAppPaused,
      };
      _channel?.invokeMethod('loadVideo', params);
    }
  }

  // ================= COMMON =================

  @override
  void didUpdateWidget(ExoVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (Platform.isAndroid) {
      if (_isViewReady && !_isAppPaused) {
        if (oldWidget.autoPlay != widget.autoPlay) {
          _updatePlaybackState();
        }
        if (oldWidget.url != widget.url) {
          _loadNewVideo();
        }
      }
    } else if (Platform.isIOS) {
      if (!_isAppPaused) {
        if (oldWidget.autoPlay != widget.autoPlay) {
          _updateIOSPlayback();
        }
        if (oldWidget.url != widget.url) {
          _loadNewIOSVideo();
        }
      }
    }
  }

  @override
  void dispose() {
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);

    _channel = null;
    _iosController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ================= ANDROID =================
    if (Platform.isAndroid) {
      const String viewType = 'com.posternova/ExoPlayerView';

      final Map<String, dynamic> creationParams = {
        'url': widget.url,
        'autoPlay': widget.autoPlay && !_isAppPaused,
      };

      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const {},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          _channel = MethodChannel('com.posternova/ExoPlayerView_${params.id}');

          return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () => params.onFocusChanged(true),
            )
            ..addOnPlatformViewCreatedListener((id) {
              params.onPlatformViewCreated(id);
              setState(() => _isViewReady = true);

              if (widget.autoPlay && !_isAppPaused) {
                _channel?.invokeMethod('play');
              } else {
                _channel?.invokeMethod('pause');
              }
            })
            ..create();
        },
      );
    }

    // ================= IOS =================
    if (Platform.isIOS) {
      if (_iosController == null || !_iosInitialized) {
        return const Center(child: CircularProgressIndicator());
      }

      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _iosController!.value.size.width,
          height: _iosController!.value.size.height,
          child: VideoPlayer(_iosController!),
        ),
      );
    }

    // ================= FALLBACK =================
    return const SizedBox();
  }
}
