import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/network_helper.dart';
import 'package:posternova/models/category_model.dart';

class PosterService {
  Future<List<CategoryModel>> fetchTemplates(String userId) async {
    print('Starting API request to fetch templates for userId: $userId');

    try {
      // Replace :userId placeholder with actual userId
      final url = ApiConstants.getAllPosters.replaceAll(':userId', userId);
      print('API URL: $url');

      final response = await http.get(Uri.parse(url));
      print('API Response Status Code: ${response.statusCode}');
      print('API Response Headers: ${response.headers}');
      print(
        'API Response Body (first 200 chars): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...',
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print('Parsed JSON data count: ${data.length}');

        if (data.isEmpty) {
          print('Warning: API returned empty list');
          return [];
        }

        print('Sample first item: ${data.isNotEmpty ? data[0] : "No items"}');
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        print(
          'API Error: Status ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception('Failed to load posters: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw 'Please turn on your internet connection';
    } catch (e) {
      print('Exception in fetchTemplates: $e');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      rethrow; // rethrow to be handled by the provider
    }
  }





  Future<Map<String, List<CategoryModel>>> fetchWeeklyTemplates(String userId) async {
  print('Starting API request to fetch weekly templates for userId: $userId');

  try {
    final url = ApiConstants.getWeeklyTemplates.replaceAll(':userId', userId);
    print('Weekly Templates API URL: $url');

    final response = await http.get(Uri.parse(url));
    print('Weekly Templates Response Status: ${response.statusCode}');


    print('Response status code for new api dataaaaaaaaa ${response.statusCode}');
        print('Response bodyyyyyyyyyyyyyyyy for new api dataaaaaaaaa ${response.body}');


    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Weekly template keys: ${data.keys.toList()}');

      final Map<String, List<CategoryModel>> result = {};
      data.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          result[key] = value
              .map((json) => CategoryModel.fromJson(json))
              .toList();
          print('Weekly "$key": ${result[key]!.length} posters');
        }
      });

      return result;
    } else {
      print('Weekly Templates API Error: ${response.statusCode}');
      throw Exception('Failed to load weekly templates: ${response.statusCode}');
    }
  } on SocketException catch (e) {
    print('No internet connection: $e');
    throw 'Please turn on your internet connection';
  } catch (e) {
    print('Exception in fetchWeeklyTemplates: $e');
    if (NetworkHelper.isNoInternetError(e)) {
      throw 'Please turn on your internet connection';
    }
    rethrow;
  }
}
}
