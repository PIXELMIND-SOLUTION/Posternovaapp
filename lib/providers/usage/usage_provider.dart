// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:posternova/services/usage/usage_storage_service.dart';

// class UsageProvider extends ChangeNotifier with WidgetsBindingObserver {
//   final UsageStorageService _storage = UsageStorageService();

//   DateTime? _startTime;
//   DateTime? get startTime => _startTime;

//   int totalSeconds = 0;
//   bool apiCalled = false;
//   String currentDate = "";

//   Timer? _timer;
//   int _tick = 0;

//   static const int rewardThreshold = 3600; // 🔥 60 min

//   bool get isCompleted => totalSeconds >= rewardThreshold;

//   /// INIT
//   Future<void> init() async {
//     WidgetsBinding.instance.addObserver(this);

//     await _checkTodayStatusFromServer(); // 🔥 IMPORTANT

//     if (!isCompleted) {
//       _startTime = DateTime.now();
//       _startTimer();
//     }
//   }

//   /// 🔥 CHECK TODAY STATUS FROM API
//   Future<void> _checkTodayStatusFromServer() async {
//     try {
//       final url = Uri.parse(
//         "http://31.97.206.144:4061/api/users/gettodayswalletrewaqrd/68d40e3f1503cc1836db8be6",
//       );

//       final response = await http.get(url);
//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["success"] == true) {
//         final duration = data["duration"] ?? 0;

//         final today = DateTime.now().toString().substring(0, 10);

//         if (duration > 0) {
//           /// ✅ Already completed from server
//           totalSeconds = rewardThreshold;
//           apiCalled = true;
//           currentDate = today;

//           await _storage.saveUsage(totalSeconds, currentDate, apiCalled);
//         } else {
//           /// 🔥 NOT completed → use LOCAL progress
//           final local = await _storage.getUsage();

//           totalSeconds = local["seconds"];
//           currentDate = local["date"];
//           apiCalled = local["apiCalled"];

//           /// 🔥 Reset only if date changed
//           if (currentDate != today) {
//             totalSeconds = 0;
//             apiCalled = false;
//             currentDate = today;

//             await _storage.saveUsage(totalSeconds, currentDate, apiCalled);
//           }
//         }

//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint("🚨 GET API ERROR: $e");
//     }
//   }

//   /// DAILY RESET
//   void _checkDateReset() {
//     final today = DateTime.now().toString().substring(0, 10);

//     if (currentDate != today) {
//       totalSeconds = 0;
//       apiCalled = false;
//       currentDate = today;
//       _save();
//     }
//   }

//   /// LIFECYCLE
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && !isCompleted) {
//       _startTime = DateTime.now();
//     } else if (state == AppLifecycleState.paused) {
//       _addSessionTime();
//     }
//   }

//   /// ADD SESSION
//   void _addSessionTime() {
//     if (_startTime != null) {
//       final diff = DateTime.now().difference(_startTime!).inSeconds;

//       if (!isCompleted) {
//         totalSeconds += diff;

//         if (totalSeconds > rewardThreshold) {
//           totalSeconds = rewardThreshold;
//         }
//       }

//       _startTime = null;

//       _save();
//       _checkAndCallApi();
//     }
//   }

//   /// TIMER
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (isCompleted) return;

//       if (_startTime != null) {
//         final diff = DateTime.now().difference(_startTime!).inSeconds;

//         totalSeconds += diff;
//         _startTime = DateTime.now();

//         if (totalSeconds > rewardThreshold) {
//           totalSeconds = rewardThreshold;
//         }

//         _tick++;

//         if (_tick % 5 == 0) {
//           _save();
//         }

//         _checkAndCallApi();
//       }
//     });
//   }

//   /// API TRIGGER
//   void _checkAndCallApi() {
//     if (isCompleted && !apiCalled) {
//       _callApi();
//     }
//   }

//   /// 🔥 POST API
//   Future<void> _callApi() async {
//     try {
//       final url = Uri.parse(
//         "http://31.97.206.144:4061/api/users/addwalletrewaqrd/68d40e3f1503cc1836db8be6",
//       );

//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "date": DateTime.now().toString().substring(0, 10),
//           "duration": 60, // minutes
//         }),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["success"] == true) {
//         apiCalled = true;
//         _save();

//         debugPrint("🎉 Reward added");
//       }
//     } catch (e) {
//       debugPrint("🚨 POST API ERROR: $e");
//     }
//   }

//   /// SAVE
//   Future<void> _save() async {
//     await _storage.saveUsage(totalSeconds, currentDate, apiCalled);
//     notifyListeners();
//   }

//   /// DISPOSE
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _timer?.cancel();
//     super.dispose();
//   }
// }


















import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/services/usage/usage_storage_service.dart';

class UsageProvider extends ChangeNotifier with WidgetsBindingObserver {
  final UsageStorageService _storage = UsageStorageService();

  DateTime? _startTime;
  DateTime? get startTime => _startTime;

  int totalSeconds = 0;
  bool apiCalled = false;
  String currentDate = "";
  String? _userId; // 👈 added

  Timer? _timer;
  int _tick = 0;

  static const int rewardThreshold = 3600; // 🔥 60 min

  bool get isCompleted => totalSeconds >= rewardThreshold;

  /// INIT
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);

    // 👇 Fetch userId from SharedPreferences
    final userData = await AuthPreferences.getUserData();
    _userId = userData?.user.id;

    if (_userId == null) {
      debugPrint("🚨 UsageProvider: No userId found, skipping usage tracking.");
      return;
    }

    await _checkTodayStatusFromServer();

    if (!isCompleted) {
      _startTime = DateTime.now();
      _startTimer();
    }
  }

  /// 🔥 CHECK TODAY STATUS FROM API
  Future<void> _checkTodayStatusFromServer() async {
    try {
      final url = Uri.parse(
        "http://31.97.228.17:4061/api/users/gettodayswalletrewaqrd/$_userId", // 👈 dynamic
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      print('geeeeeeeeeeeeeeeettttttttt apiiiiiiiiiii ${response.statusCode}');
            print('boddddddddddddddddddyyy apiiiiii ${response.body}');


      if (response.statusCode == 200 && data["success"] == true) {
        final duration = data["duration"] ?? 0;
        final today = DateTime.now().toString().substring(0, 10);

        if (duration > 0) {
          totalSeconds = rewardThreshold;
          apiCalled = true;
          currentDate = today;
          await _storage.saveUsage(totalSeconds, currentDate, apiCalled);
        } else {
          final local = await _storage.getUsage();
          totalSeconds = local["seconds"];
          currentDate = local["date"];
          apiCalled = local["apiCalled"];

          if (currentDate != today) {
            totalSeconds = 0;
            apiCalled = false;
            currentDate = today;
            await _storage.saveUsage(totalSeconds, currentDate, apiCalled);
          }
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint("🚨 GET API ERROR: $e");
    }
  }

  /// DAILY RESET
  void _checkDateReset() {
    final today = DateTime.now().toString().substring(0, 10);
    if (currentDate != today) {
      totalSeconds = 0;
      apiCalled = false;
      currentDate = today;
      _save();
    }
  }

  /// LIFECYCLE
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !isCompleted) {
      _startTime = DateTime.now();
    } else if (state == AppLifecycleState.paused) {
      _addSessionTime();
    }
  }

  /// ADD SESSION
  void _addSessionTime() {
    if (_startTime != null) {
      final diff = DateTime.now().difference(_startTime!).inSeconds;
      if (!isCompleted) {
        totalSeconds += diff;
        if (totalSeconds > rewardThreshold) totalSeconds = rewardThreshold;
      }
      _startTime = null;
      _save();
      _checkAndCallApi();
    }
  }

  /// TIMER
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isCompleted) return;
      if (_startTime != null) {
        final diff = DateTime.now().difference(_startTime!).inSeconds;
        totalSeconds += diff;
        _startTime = DateTime.now();
        if (totalSeconds > rewardThreshold) totalSeconds = rewardThreshold;
        _tick++;
        if (_tick % 5 == 0) _save();
        _checkAndCallApi();
      }
    });
  }

  /// API TRIGGER
  void _checkAndCallApi() {
    if (isCompleted && !apiCalled) _callApi();
  }

  /// 🔥 POST API
  Future<void> _callApi() async {
    try {
      final url = Uri.parse(
        "http://31.97.206.144:4061/api/users/addwalletrewaqrd/$_userId", // 👈 dynamic
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "date": DateTime.now().toString().substring(0, 10),
          "duration": 60,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        apiCalled = true;
        _save();
        debugPrint("🎉 Reward added");
      }
    } catch (e) {
      debugPrint("🚨 POST API ERROR: $e");
    }
  }

  /// SAVE
  Future<void> _save() async {
    await _storage.saveUsage(totalSeconds, currentDate, apiCalled);
    notifyListeners();
  }

  /// DISPOSE
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}