
// import 'package:flutter/material.dart';
// import 'package:posternova/models/category_model.dart';
// import 'package:posternova/services/PosterServices/getall_poster_service.dart';

// class PosterProvider extends ChangeNotifier {
//   final PosterService _service = PosterService();

//   // Add these state variables
//   List<CategoryModel> _posters = [];
//   bool _isLoading = false;
//   String? _error;

//   // Add these getters
//   List<CategoryModel> get posters => _posters;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   Future<void> fetchPosters() async {
//     print('PosterProvider: Starting fetchPosters');
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       print('PosterProvider: Calling service.fetchTemplates()');
//       _posters = await _service.fetchTemplates();
//       print('PosterProvider: Fetched ${_posters.length} posters');
      
//       // Debug: Print first poster if available
//       if (_posters.isNotEmpty) {
//         print('First poster: ${_posters[0].name}, Category: ${_posters[0].categoryName}');
//       } else {
//         print('No posters fetched from service');
//       }
      
//     } catch (e) {
//       print('PosterProvider Error: $e');
//       _error = 'Failed to load posters: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }














import 'package:flutter/material.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/services/PosterServices/getall_poster_service.dart';

class PosterProvider extends ChangeNotifier {
  final PosterService _service = PosterService();

  List<CategoryModel> _posters = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get posters => _posters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch posters using userId from stored user data
  Future<void> fetchPosters() async {
    print('PosterProvider: Starting fetchPosters');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get userId from stored user data
      final userData = await AuthPreferences.getUserData();
      
      if (userData == null || userData.user.id == null) {
        throw 'User not logged in';
      }
      
      final userId = userData.user.id!;
      print('PosterProvider: Fetching posters for userId: $userId');
      
      _posters = await _service.fetchTemplates(userId);
      print('PosterProvider: Fetched ${_posters.length} posters');
      
      // Debug: Print first poster if available
      if (_posters.isNotEmpty) {
        print('First poster: ${_posters[0].name}, Category: ${_posters[0].categoryName}');
      } else {
        print('No posters fetched from service');
      }
      
    } catch (e) {
      print('PosterProvider Error: $e');
      _error = 'Failed to load posters: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch posters with explicit userId parameter (optional alternative method)
  Future<void> fetchPostersWithUserId(String userId) async {
    print('PosterProvider: Starting fetchPostersWithUserId for: $userId');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('PosterProvider: Calling service.fetchTemplates()');
      _posters = await _service.fetchTemplates(userId);
      print('PosterProvider: Fetched ${_posters.length} posters');
      
      if (_posters.isNotEmpty) {
        print('First poster: ${_posters[0].name}, Category: ${_posters[0].categoryName}');
      } else {
        print('No posters fetched from service');
      }
      
    } catch (e) {
      print('PosterProvider Error: $e');
      _error = 'Failed to load posters: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear posters and reset state
  void clearPosters() {
    _posters = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}