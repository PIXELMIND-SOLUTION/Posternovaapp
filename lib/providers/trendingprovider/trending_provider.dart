// import 'package:flutter/foundation.dart';
// import 'package:posternova/models/trending_model.dart';
// import 'package:posternova/services/trendingcategory/trending_category_services.dart';


// enum PosterCategoryStatus { initial, loading, loaded, error }

// class PosterCategoryProvider extends ChangeNotifier {
//   final PosterCategoryService _service;

//   PosterCategoryProvider({PosterCategoryService? service})
//       : _service = service ?? PosterCategoryService();

//   PosterCategoryStatus _status = PosterCategoryStatus.initial;
//   List<PosterCategoryModel> _categories = [];
//   String? _errorMessage;

//   PosterCategoryStatus get status => _status;
//   List<PosterCategoryModel> get categories => List.unmodifiable(_categories);
//   String? get errorMessage => _errorMessage;
//   bool get isLoading => _status == PosterCategoryStatus.loading;
//   bool get hasError => _status == PosterCategoryStatus.error;
//   bool get hasData =>
//       _status == PosterCategoryStatus.loaded && _categories.isNotEmpty;
//   int get count => _categories.length;

//   Future<void> fetchCategories({bool forceRefresh = false}) async {
//     if (_status == PosterCategoryStatus.loaded && !forceRefresh) return;
//     _setStatus(PosterCategoryStatus.loading);
//     try {
//       final response = await _service.getCategories();
//       _categories = response.categories;
//       _errorMessage = null;
//       _setStatus(PosterCategoryStatus.loaded);
//     } on PosterCategoryServiceException catch (e) {
//       _errorMessage = e.message;
//       _setStatus(PosterCategoryStatus.error);
//     } catch (e) {
//       _errorMessage = 'Unexpected error: $e';
//       _setStatus(PosterCategoryStatus.error);
//     }
//   }

//   Future<void> refresh() => fetchCategories(forceRefresh: true);

//   void _setStatus(PosterCategoryStatus status) {
//     _status = status;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _service.dispose();
//     super.dispose();
//   }
// }
















import 'package:flutter/foundation.dart';
import 'package:posternova/models/trending_model.dart';
import 'package:posternova/services/trendingcategory/trending_category_services.dart';

enum PosterCategoryStatus { initial, loading, loaded, error }
enum PosterSubcategoryStatus { initial, loading, loaded, error }

class PosterCategoryProvider extends ChangeNotifier {
  final PosterCategoryService _service;

  PosterCategoryProvider({PosterCategoryService? service})
      : _service = service ?? PosterCategoryService();

  // ─── Category state ──────────────────────────────────────────────────────────

  PosterCategoryStatus _categoryStatus = PosterCategoryStatus.initial;
  List<PosterCategoryModel> _categories = [];
  String? _categoryError;

  PosterCategoryStatus get status => _categoryStatus;
  List<PosterCategoryModel> get categories => List.unmodifiable(_categories);
  String? get errorMessage => _categoryError;
  bool get isLoading => _categoryStatus == PosterCategoryStatus.loading;
  bool get hasError => _categoryStatus == PosterCategoryStatus.error;
  bool get hasData =>
      _categoryStatus == PosterCategoryStatus.loaded && _categories.isNotEmpty;
  int get count => _categories.length;

  // ─── Subcategory state ───────────────────────────────────────────────────────

  PosterSubcategoryStatus _subcategoryStatus = PosterSubcategoryStatus.initial;
  List<PosterSubcategoryModel> _posters = [];
  String? _subcategoryError;
  String? _loadedCategoryId;
  String? _loadedCategoryName;
  int _postersCount = 0;

  PosterSubcategoryStatus get subcategoryStatus => _subcategoryStatus;
  List<PosterSubcategoryModel> get posters => List.unmodifiable(_posters);
  String? get subcategoryError => _subcategoryError;
  bool get isSubcategoryLoading =>
      _subcategoryStatus == PosterSubcategoryStatus.loading;
  bool get hasSubcategoryError =>
      _subcategoryStatus == PosterSubcategoryStatus.error;
  bool get hasPosters =>
      _subcategoryStatus == PosterSubcategoryStatus.loaded &&
      _posters.isNotEmpty;
  int get postersCount => _postersCount;
  String? get loadedCategoryId => _loadedCategoryId;
  String? get loadedCategoryName => _loadedCategoryName;

  /// Trending posters derived from the loaded posters list
  List<PosterSubcategoryModel> get trendingPosters =>
      _posters.where((p) => p.isTrending).toList();

  // ─── Category actions ────────────────────────────────────────────────────────

  Future<void> fetchCategories({bool forceRefresh = false}) async {
    if (_categoryStatus == PosterCategoryStatus.loaded && !forceRefresh) return;
    _categoryStatus = PosterCategoryStatus.loading;
    notifyListeners();
    try {
      final response = await _service.getCategories();
      _categories = response.categories;
      _categoryError = null;
      _categoryStatus = PosterCategoryStatus.loaded;
    } on PosterCategoryServiceException catch (e) {
      _categoryError = e.message;
      _categoryStatus = PosterCategoryStatus.error;
    } catch (e) {
      _categoryError = 'Unexpected error: $e';
      _categoryStatus = PosterCategoryStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => fetchCategories(forceRefresh: true);

  // ─── Subcategory actions ─────────────────────────────────────────────────────

  Future<void> fetchSubcategories(
    String categoryId, {
    bool forceRefresh = false,
  }) async {
    // Skip if already loaded for same category and no forced refresh
    if (!forceRefresh &&
        _subcategoryStatus == PosterSubcategoryStatus.loaded &&
        _loadedCategoryId == categoryId) return;

    _subcategoryStatus = PosterSubcategoryStatus.loading;
    notifyListeners();

    try {
      final response = await _service.getSubcategories(categoryId);
      _posters = response.posters;
      _postersCount = response.count;
      _loadedCategoryId = response.categoryId;
      _loadedCategoryName = response.categoryName;
      _subcategoryError = null;
      _subcategoryStatus = PosterSubcategoryStatus.loaded;
    } on PosterCategoryServiceException catch (e) {
      _subcategoryError = e.message;
      _subcategoryStatus = PosterSubcategoryStatus.error;
    } catch (e) {
      _subcategoryError = 'Unexpected error: $e';
      _subcategoryStatus = PosterSubcategoryStatus.error;
    }
    notifyListeners();
  }

  Future<void> refreshSubcategories(String categoryId) =>
      fetchSubcategories(categoryId, forceRefresh: true);

  /// Clears loaded posters (e.g. when navigating away)
  void clearPosters() {
    _posters = [];
    _loadedCategoryId = null;
    _loadedCategoryName = null;
    _postersCount = 0;
    _subcategoryStatus = PosterSubcategoryStatus.initial;
    notifyListeners();
  }

  // ─── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}