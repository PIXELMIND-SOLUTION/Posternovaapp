// import 'dart:async';
// import 'package:flutter/services.dart';

// class ExoPlayer {
//   static const MethodChannel _channel = MethodChannel('com.your.app/exoplayer');

//   static Future<void> playVideo(String url) async {
//     try {
//       await _channel.invokeMethod('playVideo', {'url': url});
//     } on PlatformException catch (e) {
//       print('Failed to play video: ${e.message}');
//     }
//   }

//   static Future<void> pause() async {
//     await _channel.invokeMethod('pause');
//   }

//   static Future<void> resume() async {
//     await _channel.invokeMethod('resume');
//   }

//   static Future<void> stop() async {
//     await _channel.invokeMethod('stop');
//   }
// }
