// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class VoiceGreetingHelper {
//   static final FlutterTts _flutterTts = FlutterTts();
//   static bool _isInitialized = false;

//   // Initialize TTS settings
//   static Future<void> initialize() async {
//     if (_isInitialized) return;
    
//     try {
//       await _flutterTts.setLanguage("en-US");
//       await _flutterTts.setSpeechRate(0.5); // Adjust speed (0.0 to 1.0)
//       await _flutterTts.setVolume(1.0); // Adjust volume (0.0 to 1.0)
//       await _flutterTts.setPitch(1.0); // Adjust pitch (0.5 to 2.0)
//       _isInitialized = true;
//     } catch (e) {
//       print("Error initializing TTS: $e");
//     }
//   }

//   // Speak the welcome message
//   static Future<void> speakWelcome(String? username) async {
//     try {
//       await initialize();
      
//       // Check if greeting was already spoken today
//       final prefs = await SharedPreferences.getInstance();
//       final today = DateTime.now().toString().split(' ')[0];
//       final lastGreeting = prefs.getString('last_voice_greeting');
      
//       if (lastGreeting == today) {
//         print("Voice greeting already played today");
//         return;
//       }
      
//       // Get time-based greeting
//       final hour = DateTime.now().hour;
//       String timeGreeting;
      
//       if (hour < 12) {
//         timeGreeting = "Good morning";
//       } else if (hour < 17) {
//         timeGreeting = "Good afternoon";
//       } else {
//         timeGreeting = "Good evening";
//       }
      
//       // Create personalized message
//       String message = username != null && username.isNotEmpty
//           ? "$timeGreeting, $username! Welcome back to EditEzy."
//           : "$timeGreeting! Welcome back to EditEzy.";
      
//       // Speak the message
//       await _flutterTts.speak(message);
      
//       // Save that greeting was spoken today
//       await prefs.setString('last_voice_greeting', today);
      
//       print("Voice greeting played: $message");
//     } catch (e) {
//       print("Error speaking welcome: $e");
//     }
//   }

//   // Stop speaking
//   static Future<void> stop() async {
//     try {
//       await _flutterTts.stop();
//     } catch (e) {
//       print("Error stopping TTS: $e");
//     }
//   }

//   // Dispose resources
//   static void dispose() {
//     _isInitialized = false;
//   }
// }













import 'package:flutter_tts/flutter_tts.dart';

class VoiceGreetingHelper {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;
  static bool _isSpeaking = false;

  // Initialize TTS settings
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5); // Adjust speed (0.0 to 1.0)
      await _flutterTts.setVolume(1.0); // Adjust volume (0.0 to 1.0)
      await _flutterTts.setPitch(1.0); // Adjust pitch (0.5 to 2.0)
      
      // Set completion handler
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });
      
      _isInitialized = true;
    } catch (e) {
      print("Error initializing TTS: $e");
    }
  }

  // Speak the welcome message - will play every time
  static Future<void> speakWelcome(String? username) async {
    // Prevent multiple simultaneous speeches
    if (_isSpeaking) {
      print("Already speaking, skipping...");
      return;
    }

    try {
      await initialize();
      _isSpeaking = true;
      
      // Get time-based greeting
      final hour = DateTime.now().hour;
      String timeGreeting;
      
      if (hour < 12) {
        timeGreeting = "Good morning";
      } else if (hour < 17) {
        timeGreeting = "Good afternoon";
      } else {
        timeGreeting = "Good evening";
      }
      
      // Create personalized message
      String message = username != null && username.isNotEmpty
          ? "$timeGreeting, $username! Welcome back to EditEzy."
          : "$timeGreeting! Welcome back to EditEzy.";
      
      // Speak the message
      await _flutterTts.speak(message);
      
      print("Voice greeting played: $message");
    } catch (e) {
      print("Error speaking welcome: $e");
      _isSpeaking = false;
    }
  }

  // Stop speaking
  static Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
    } catch (e) {
      print("Error stopping TTS: $e");
    }
  }

  // Dispose resources
  static void dispose() {
    _isInitialized = false;
    _isSpeaking = false;
  }
}