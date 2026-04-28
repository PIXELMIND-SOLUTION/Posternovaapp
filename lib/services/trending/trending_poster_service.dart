import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/trending_poster_model.dart';

class TrendingPosterService {
  static const String _baseUrl = 'http://api.editezy.com/api';

  /// Fetch all trending posters for a given category/business ID
  static Future<List<TrendingPoster>> getAllTrendingPosters(String businessId) async {
    try {
      final token = await AuthPreferences.getToken();

      final uri = Uri.parse('$_baseUrl/poster/getalltrendingposter/$businessId');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => TrendingPoster.fromJson(e)).toList();
      } else {
        throw TrendingPosterException(
          'Failed to fetch trending posters',
          statusCode: response.statusCode,
        );
      }
    } on TrendingPosterException {
      rethrow;
    } catch (e) {
      throw TrendingPosterException('Unexpected error: $e');
    }
  }
}

class TrendingPosterException implements Exception {
  final String message;
  final int? statusCode;

  TrendingPosterException(this.message, {this.statusCode});

  @override
  String toString() =>
      'TrendingPosterException: $message${statusCode != null ? ' (HTTP $statusCode)' : ''}';
}