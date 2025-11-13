import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/network_helper.dart';
import 'package:posternova/models/category_model.dart';

class PosterService {
  Future<List<CategoryModel>> fetchTemplates() async {
    print('Starting API request to fetch templates');
    
    try {
      final response = await http.get(Uri.parse(ApiConstants.getAllPosters));
      print('API Response Status Code: ${response.statusCode}');
      print('API Response Headers: ${response.headers}');
      print('API Response Body (first 200 chars): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');
      
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
        print('API Error: Status ${response.statusCode}, Body: ${response.body}');
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
}