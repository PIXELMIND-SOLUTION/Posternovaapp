// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:posternova/models/trending_model.dart';

// class PosterCategoryService {
//   static const String _baseUrl = 'http://31.97.228.17:4061/api/poster';

//   final http.Client _client;

//   PosterCategoryService({http.Client? client})
//       : _client = client ?? http.Client();

//   Future<PosterCategoriesResponse> getCategories() async {
//     final uri = Uri.parse('$_baseUrl/categories');
//     try {
//       final response = await _client.get(
//         uri,
//         headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
//       );
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> json =
//             jsonDecode(response.body) as Map<String, dynamic>;
//         return PosterCategoriesResponse.fromJson(json);
//       } else {
//         throw PosterCategoryServiceException(
//           'Failed to fetch categories. Status: ${response.statusCode}',
//           statusCode: response.statusCode,
//         );
//       }
//     } on PosterCategoryServiceException {
//       rethrow;
//     } catch (e) {
//       throw PosterCategoryServiceException('Unexpected error: $e');
//     }
//   }

//   void dispose() => _client.close();
// }

// class PosterCategoryServiceException implements Exception {
//   final String message;
//   final int? statusCode;
//   PosterCategoryServiceException(this.message, {this.statusCode});

//   @override
//   String toString() => 'PosterCategoryServiceException: $message'
//       '${statusCode != null ? ' (status: $statusCode)' : ''}';
// }














import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/models/trending_model.dart';

class PosterCategoryService {
  static const String _baseUrl = 'http://31.97.228.17:4061/api/poster';

  final http.Client _client;

  PosterCategoryService({http.Client? client})
      : _client = client ?? http.Client();

  Future<PosterCategoriesResponse> getCategories() async {
    final uri = Uri.parse('$_baseUrl/categories');
    try {
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return PosterCategoriesResponse.fromJson(json);
      }
      throw PosterCategoryServiceException(
        'Failed to fetch categories. Status: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on PosterCategoryServiceException {
      rethrow;
    } catch (e) {
      throw PosterCategoryServiceException('Unexpected error: $e');
    }
  }

  Future<PosterSubcategoriesResponse> getSubcategories(
      String categoryId) async {
    final uri = Uri.parse('$_baseUrl/subcategori/$categoryId');
    try {
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return PosterSubcategoriesResponse.fromJson(json);
      }
      throw PosterCategoryServiceException(
        'Failed to fetch subcategories. Status: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on PosterCategoryServiceException {
      rethrow;
    } catch (e) {
      throw PosterCategoryServiceException('Unexpected error: $e');
    }
  }

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void dispose() => _client.close();
}

class PosterCategoryServiceException implements Exception {
  final String message;
  final int? statusCode;

  PosterCategoryServiceException(this.message, {this.statusCode});

  @override
  String toString() => 'PosterCategoryServiceException: $message'
      '${statusCode != null ? ' (status: $statusCode)' : ''}';
}