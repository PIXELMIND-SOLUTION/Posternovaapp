import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/models/subscribe_plan_model.dart';

class MyPlanServices {
  // Future<SubscribePlanModel?> fetchUserPlan(String userId) async {
  //   final url = Uri.parse(ApiConstants.getMyPlan(userId));

  //   try {
  //     print('🔍 Fetching plan for userId: $userId');
  //     print('🌐 Request URL: $url');

  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         // Add any additional headers your API requires
  //         // 'Authorization': 'Bearer your_token_here',
  //       },
  //     );

  //     print('📊 Response Status Code: ${response.statusCode}');
  //     print('📄 Response Body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       // Check if response body is not empty
  //       if (response.body.isEmpty) {
  //         print('⚠️ Response body is empty');
  //         return null;
  //       }

  //       try {
  //         final Map<String, dynamic> jsonData = json.decode(response.body);
  //         print('✅ Parsed JSON: $jsonData');

  //         // Check if the response is successful
  //         if (jsonData['success'] != true) {
  //           print('⚠️ API returned success: false');
  //           return null;
  //         }

  //         // Check if user has subscribed plans
  //         final bool isSubscribedPlan = jsonData['isSubscribedPlan'] ?? false;
  //         if (!isSubscribedPlan) {
  //           print('⚠️ User has no subscribed plans');
  //           return null;
  //         }

  //         // Get the subscribedPlans array
  //         final List<dynamic>? subscribedPlans = jsonData['subscribedPlans'];

  //         if (subscribedPlans == null || subscribedPlans.isEmpty) {
  //           print('⚠️ subscribedPlans array is null or empty');
  //           return null;
  //         }

  //         // Get the first subscribed plan (you can modify this logic if you need to handle multiple plans)
  //         final Map<String, dynamic> planData = subscribedPlans.first;

  //         print('🔍 Plan data to parse: $planData');

  //         // Create the model from the plan data
  //         return SubscribePlanModel.fromJson(planData);
  //       } catch (jsonError) {
  //         print('❌ JSON parsing error: $jsonError');
  //         print('📄 Raw response body: ${response.body}');
  //         throw Exception('Invalid JSON response: $jsonError');
  //       }
  //     } else if (response.statusCode == 404) {
  //       print('❌ Plan not found for user: $userId');
  //       return null;
  //     } else if (response.statusCode == 401) {
  //       throw Exception('Unauthorized access - check your authentication');
  //     } else if (response.statusCode >= 500) {
  //       throw Exception('Server error: ${response.statusCode}');
  //     } else {
  //       throw Exception(
  //         'Failed to load user plan: ${response.statusCode} - ${response.body}',
  //       );
  //     }
  //   } on http.ClientException catch (e) {
  //     print('❌ Network error: $e');
  //     throw Exception('Network error: $e');
  //   } on FormatException catch (e) {
  //     print('❌ Format error: $e');
  //     throw Exception('Data format error: $e');
  //   } catch (e) {
  //     print('❌ Unexpected error: $e');
  //     throw Exception('Error fetching user plan: $e');
  //   }
  // }



  Future<SubscribePlanModel?> fetchUserPlan(String userId) async {
  final url = Uri.parse(ApiConstants.getMyPlan(userId));

  try {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) return null;

    final Map<String, dynamic> jsonData = json.decode(response.body);

    if (jsonData['success'] != true) return null;

    final bool isSubscribedPlan = jsonData['isSubscribedPlan'] ?? false;
    final bool free7DayTrial = jsonData['free7DayTrial'] ?? false;

    // ✅ CASE 1: Paid plan exists
    if (isSubscribedPlan == true &&
        jsonData['subscribedPlans'] != null &&
        jsonData['subscribedPlans'].isNotEmpty) {
      return SubscribePlanModel.fromJson(
        jsonData['subscribedPlans'].first,
      );
    }

    // ✅ CASE 2: Free trial (NO subscribed plans)
    if (free7DayTrial == true) {
      return SubscribePlanModel(
        id: 'FREE_TRIAL',
        name: '7 Days Free Trial',
        originalPrice: 0,
        offerPrice: 0,
        discountPercentage: 100,
        duration: '7 days',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        isSubscribedPlan: false,
        free7DayTrial: true,
        isSelected: true,
      );
    }

    // ❌ CASE 3: No plan & no trial
    return null;
  } catch (e) {
    throw Exception('Error fetching user plan: $e');
  }
}

}
