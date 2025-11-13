import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/models/subscribe_plan_model.dart';

class MyPlanServices {
  Future<SubscribePlanModel?> fetchUserPlan(String userId) async {
    final url = Uri.parse(ApiConstants.getMyPlan(userId));
    
    try {
      print('🔍 Fetching plan for userId: $userId');
      print('🌐 Request URL: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers your API requires
          // 'Authorization': 'Bearer your_token_here',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      print('📊 Response Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if response body is not empty
        if (response.body.isEmpty) {
          print('⚠️ Response body is empty');
          return null;
        }

        try {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          print('✅ Parsed JSON: $jsonData');
          
          // Check if the response is successful
          if (jsonData['success'] != true) {
            print('⚠️ API returned success: false');
            return null;
          }

          // Check if user has subscribed plans
          final bool isSubscribedPlan = jsonData['isSubscribedPlan'] ?? false;
          if (!isSubscribedPlan) {
            print('⚠️ User has no subscribed plans');
            return null;
          }

          // Get the subscribedPlans array
          final List<dynamic>? subscribedPlans = jsonData['subscribedPlans'];
          
          if (subscribedPlans == null || subscribedPlans.isEmpty) {
            print('⚠️ subscribedPlans array is null or empty');
            return null;
          }

          // Get the first subscribed plan (you can modify this logic if you need to handle multiple plans)
          final Map<String, dynamic> planData = subscribedPlans.first;
          
          print('🔍 Plan data to parse: $planData');
          
          // Create the model from the plan data
          return SubscribePlanModel.fromJson(planData);
          
        } catch (jsonError) {
          print('❌ JSON parsing error: $jsonError');
          print('📄 Raw response body: ${response.body}');
          throw Exception('Invalid JSON response: $jsonError');
        }
      } else if (response.statusCode == 404) {
        print('❌ Plan not found for user: $userId');
        return null;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access - check your authentication');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error: ${response.statusCode}');
      } else {
        throw Exception('Failed to load user plan: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: $e');
    } on FormatException catch (e) {
      print('❌ Format error: $e');
      throw Exception('Data format error: $e');
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('Error fetching user plan: $e');
    }
  }
}