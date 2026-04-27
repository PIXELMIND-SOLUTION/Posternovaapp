import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/models/poster_model.dart';

class NewCanvasPosterService {
  static const String baseUrl = 'http://31.97.228.17:4061/api/poster';

  // Fetch weekly posters from the API
  Future<List<CanvasPosterModel>> fetchWeeklyPosters(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weeklyposters/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      
     
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // The API returns data grouped by day names (Sunday, Monday, etc.)
        List<CanvasPosterModel> allPosters = [];
        
        // Iterate through each day's posters
        data.forEach((dayName, postersList) {
          if (postersList is List) {
            for (var posterJson in postersList) {
              try {
                final poster = CanvasPosterModel.fromJson(posterJson);
                allPosters.add(poster);
              } catch (e) {
                print('Error parsing poster: $e');
              }
            }
          }
        });
        
        return allPosters;
      } else {
        throw Exception('Failed to load weekly posters: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchWeeklyPosters: $e');
      throw Exception('Failed to fetch weekly posters: $e');
    }
  }

  // Keep your existing fetchCanvasPosters method if you still need it
  Future<List<CanvasPosterModel>> fetchCanvasPosters() async {
    // Your existing implementation
    return [];
  }
}