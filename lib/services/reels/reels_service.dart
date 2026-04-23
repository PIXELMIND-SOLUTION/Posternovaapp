import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/models/reels_model.dart';

class ReelService {
  static const String baseUrl = 'http://82.29.162.67:4061/api/users';

  // Get all reels for a user
  Future<ReelsResponse?> getAllReels(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/allreels/$userId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Get All Reels Status Code: ${response.statusCode}');
      print('Get All Reels Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return ReelsResponse.fromJson(jsonData);
      } else {
        print('Failed to get reels: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting all reels: $e');
      return null;
    }
  }

  // Like a reel
  Future<LikeReelResponse?> likeReel(String reelId, String userId) async {
    try {
      final url = Uri.parse('$baseUrl/likereel/$reelId/$userId');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Like Reel Status Code: ${response.statusCode}');
      print('Like Reel Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return LikeReelResponse.fromJson(jsonData);
      } else {
        print('Failed to like reel: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error liking reel: $e');
      return null;
    }
  }

  // Unlike a reel (if you have an unlike endpoint)
  Future<LikeReelResponse?> unlikeReel(String reelId, String userId) async {
    try {
      final url = Uri.parse('$baseUrl/unlikereel/$reelId/$userId');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Unlike Reel Status Code: ${response.statusCode}');
      print('Unlike Reel Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return LikeReelResponse.fromJson(jsonData);
      } else {
        print('Failed to unlike reel: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error unliking reel: $e');
      return null;
    }
  }
}