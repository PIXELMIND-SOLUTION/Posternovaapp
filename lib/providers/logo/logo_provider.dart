

// import 'package:flutter/material.dart';
// import 'package:posternova/models/logo_model.dart';
// import 'package:posternova/services/logo/logo_service.dart';
// // Adjust the path accordingly

// class LogoProvider extends ChangeNotifier {
//   final LogoService _logoService = LogoService();

//   List<LogoItem> _logos = [];
//   List<LogoItem> get logos => _logos;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _error;
//   String? get error => _error;

//   Future<void> fetchLogos() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       _logos = await _logoService.fetchLogos();
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }














// // logo_provider.dart
// import 'package:flutter/material.dart';
// import 'package:posternova/models/logo_model.dart';
// import 'package:posternova/services/logo/logo_service.dart';

// class LogoProvider extends ChangeNotifier {
//   final LogoService _logoService = LogoService();

//   List<LogoItem> _logos = [];
//   List<LogoItem> get logos => _logos;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _error;
//   String? get error => _error;

//   String? _currentLogoCategoryId;
//   String? get currentLogoCategoryId => _currentLogoCategoryId;

//   Future<void> fetchLogos({required String logoCategoryId}) async {
//     _isLoading = true;
//     _error = null;
//     _currentLogoCategoryId = logoCategoryId;
//     notifyListeners();

//     try {
//       _logos = await _logoService.fetchLogos(logoCategoryId: logoCategoryId);
//     } catch (e) {
//       _error = e.toString();
//       _logos = []; // Clear logos on error
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Optional: Method to clear logos
//   void clearLogos() {
//     _logos = [];
//     _error = null;
//     _currentLogoCategoryId = null;
//     notifyListeners();
//   }
// }












// logo_provider.dart
import 'package:flutter/material.dart';
import 'package:posternova/models/logo_model.dart';
import 'package:posternova/services/logo/logo_service.dart';

class LogoProvider extends ChangeNotifier {
  final LogoService _logoService = LogoService();

  List<LogoItem> _logos = [];
  List<LogoItem> get logos => _logos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _currentLogoCategoryId;
  String? get currentLogoCategoryId => _currentLogoCategoryId;

  Future<void> fetchLogos({
    required String userId,
    required String logoCategoryId,
  }) async {
    _isLoading = true;
    _error = null;
    _currentLogoCategoryId = logoCategoryId;
    notifyListeners();

    try {
      _logos = await _logoService.fetchLogos(
        userId: userId,
        logoCategoryId: logoCategoryId,
      );
    } catch (e) {
      _error = e.toString();
      _logos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearLogos() {
    _logos = [];
    _error = null;
    _currentLogoCategoryId = null;
    notifyListeners();
  }
}