// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:posternova/constants/api_constant.dart';
// import 'package:posternova/models/category_model.dart';

// class CategoryPosterService {
//   Future<List<CategoryModel>> fetchPostersByCategory(String category) async {
//     print('Fetching posters for category: $category');
//     try {
//       // Make GET request using http.Request to send body
//       final request = http.Request('GET', Uri.parse(ApiConstants.getposterbyCategory))
//         ..headers.addAll({
//           'Content-Type': 'application/json',
//         })
//         ..body = json.encode({
//           "categoryName": category,
//         });


//         print('categoryyyyyyyyyyyyyyyyyyyyyyyyyy nameeeeeeeeee$category');

//       final response = await request.send();
      
//       final responseString = await response.stream.bytesToString();
//       print('Response Status: ${response.statusCode}');
//       print('Response Body: $responseString');

//       if (response.statusCode == 200) {
//         try {
//           // Parse the JSON response - directly as a List since the API returns an array
//           final List responseData = json.decode(responseString);
          
//           // Convert each item to CategoryModel
//           return List.from(
//             responseData.map((item) => CategoryModel.fromJson(item))
//           );
//         } catch (parseError) {
//           print('JSON Parse Error: $parseError');
//           throw Exception('Failed to parse response: $parseError');
//         }
//       } else {
//         print('HTTP Error: ${response.statusCode}');
//         print('Response body: $responseString');
//         throw Exception('Failed to load posters: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Network Error: $e');
//       throw Exception('Error fetching posters: $e');
//     }
//   }
// }










import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/models/category_model.dart';

class CategoryPosterService {
  Future<List<CategoryModel>> fetchPostersByCategory(String category) async {
    print('Fetching posters for category: $category');
    try {
      // Build URL with query parameter instead of request body
      final uri = Uri.parse(ApiConstants.getposterbyCategory).replace(
        queryParameters: {
          'categoryName': category,
        },
      );

      print('Request URL: $uri');

      // Make GET request without body
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          // Parse the JSON response - directly as a List since the API returns an array
          final List responseData = json.decode(response.body);
          
          // Convert each item to CategoryModel
          return List.from(
            responseData.map((item) => CategoryModel.fromJson(item))
          );
        } catch (parseError) {
          print('JSON Parse Error: $parseError');
          throw Exception('Failed to parse response: $parseError');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load posters: ${response.statusCode}');
      }
    } catch (e) {
      print('Network Error: $e');
      throw Exception('Error fetching posters: $e');
    }
  }
}