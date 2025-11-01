import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/redeem_model.dart';

class RedeemService {
  Future<RedeemResponse?> submitRedemption({
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String bankName,
    required String upiId,
  }) async {
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData == null) {
        throw Exception('User not logged in');
      }

      final userId = userData.user.id;
      final token = await AuthPreferences.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse(ApiConstants.redeem(userId));
      
      final payload = {
        "accountHolderName": accountHolderName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "bankName": bankName,
        "upiId":upiId
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      print('Redeem API Response Status: ${response.statusCode}');
      print('Redeem API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return RedeemResponse.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to submit redemption request');
      }
    } catch (e) {
      print('Error in submitRedemption: $e');
      throw Exception('Failed to submit redemption: $e');
    }
  }

  Future<List<RedemptionHistory>?> getRedemptionHistory() async {
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData == null) {
        throw Exception('User not logged in');
      }

      final userId = userData.user.id;
      final token = await AuthPreferences.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Using the redeem endpoint from ApiConstants and appending /history
      final url = Uri.parse('${ApiConstants.redeem(userId)}/history');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> historyList = responseData['redemptions'] ?? [];
        return historyList.map((item) => RedemptionHistory.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch redemption history');
      }
    } catch (e) {
      print('Error in getRedemptionHistory: $e');
      return null;
    }
  }
}