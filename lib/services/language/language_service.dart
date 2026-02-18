import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://31.97.206.144:4061/api';
  
  static Future<bool> updateUserLanguage(String userId, String language) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/update-lang/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'language': language,
        }),
      );

      print('response status code for update profileeee ${response.statusCode}');
            print('response bodyyyyyyyyy for update profileeee ${response.body}');

      
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating language: $e');
      return false;
    }
  }
}