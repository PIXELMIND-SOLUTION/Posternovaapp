import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/storage_helper.dart';

class ReportStoryService {
  Future<Map<String, dynamic>> reportUser({
    required String userId,
    required String reportedUserId,
  }) async {
    try {
      // Get auth token
      final token = await AuthPreferences.getToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token not found'
        };
      }

      final url = Uri.parse(ApiConstants.reportUser(userId, reportedUserId));
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'isReported': true,
        }),
      );

      print('Report API Response Status: ${response.statusCode}');
      print('Report API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'User reported successfully',
          'data': responseData,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to report user',
        };
      }
    } catch (e) {
      print('Error reporting user: $e');
      return {
        'success': false,
        'message': 'Network error occurred while reporting user',
      };
    }
  }

  Future<Map<String, dynamic>> blockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      // Get auth token
      final token = await AuthPreferences.getToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token not found'
        };
      }

      final url = Uri.parse(ApiConstants.blockUser(userId, blockedUserId));
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'isBlocked': true,
        }),
      );

      print('Block API Response Status: ${response.statusCode}');
      print('Block API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'User blocked successfully',
          'data': responseData,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to block user',
        };
      }
    } catch (e) {
      print('Error blocking user: $e');
      return {
        'success': false,
        'message': 'Successfully Reported',
      };
    }
  }
}