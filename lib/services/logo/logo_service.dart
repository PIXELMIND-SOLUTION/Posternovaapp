// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:posternova/constants/api_constant.dart';
// import 'package:posternova/models/logo_model.dart';

// class LogoService {
//   Future<List<LogoItem>> fetchLogos() async {
//     try {
//       final response = await http.get(Uri.parse(ApiConstants.getLogos));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data.map((jsonItem) => LogoItem.fromjson(jsonItem)).toList();
//       } else {
//         throw Exception('Failed to load logos: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching logos: $e');
//     }
//   }
// }















// logo_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:posternova/constants/api_constant.dart';
// import 'package:posternova/models/logo_model.dart';

// class LogoService {
//   Future<List<LogoItem>> fetchLogos({required String logoCategoryId}) async {
//     try {
//       final uri = Uri.parse(ApiConstants.getLogos).replace(
//         queryParameters: {'logoCategoryId': logoCategoryId},
//       );
      
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data.map((jsonItem) => LogoItem.fromjson(jsonItem)).toList();
//       } else {
//         throw Exception('Failed to load logos: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching logos: $e');
//     }
//   }
// }




// logo_service.dart


import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/models/logo_model.dart';

class LogoService {
  Future<List<LogoItem>> fetchLogos({
    required String userId,
    required String logoCategoryId,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.getLogos}/$userId').replace(
        queryParameters: {'logoCategoryId': logoCategoryId},
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((jsonItem) => LogoItem.fromjson(jsonItem)).toList();
      } else {
        throw Exception('Failed to load logos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching logos: $e');
    }
  }
}