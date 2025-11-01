import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/network_helper.dart';
import 'package:posternova/models/poster_model.dart';

class NewCanvasPosterService {
  Future<List<CanvasPosterModel>> fetchCanvasPosters() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.canvaPosters));

      print('Raw Response Status Code: ${response.statusCode}');
      print('Raw Response Body: ${response.body}');
        
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // Fixed: Use 'posters' instead of 'poster' to match your JSON response
        final List<dynamic> postersJson = decoded['posters'] ?? [];

        return postersJson
            .map((json) => CanvasPosterModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load canvas posters: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw 'Please turn on your internet connection';
    } catch (e, stackTrace) {
      print('Error details: $e');
      print('Stack trace: $stackTrace');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      throw Exception('Error fetching canvas posters: $e');
    }
  }
}