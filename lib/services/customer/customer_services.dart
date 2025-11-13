import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/network_helper.dart';

class CustomerApiServices {
  /// Add Customer
  Future<bool> addCustomer({
    required String userId,
    required String name,
    required String email,
    required String mobile,
    required String dob,
    required String address,
    required String gender,
    required String anniversaryDate,
  }) async {
    final Uri url = Uri.parse(ApiConstants.addCustomer(userId));

    final Map<String, dynamic> body = {"customer":{
      'name': name,
      'email': email,
      'mobile': mobile,
      'dob': dob,
      'address': address,
      'gender': gender,
      'anniversaryDate': anniversaryDate,
    }};

    try {
      print("=== ADD CUSTOMER DEBUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG ===");
      print("User ID: $dob");
            print("User ID: $anniversaryDate");

      print("Payloaddddddddddddddddddddddddddddddddddddddddddddddddd: ${jsonEncode(body)}");
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("========================");
      
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        return true;
      } else {
        print('Failed to add customer: ${response.statusCode}');
        return false;
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw 'Please turn on your internet connection';
    } catch (e) {
      print('Error adding customer: $e');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      return false;
    }
  }

  /// Fetch User (with customer list)
  Future<Map<String, dynamic>?> fetchUser(String userId) async {
    final Uri url = Uri.parse(ApiConstants.fetchUser(userId));

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch user: ${response.statusCode}');
        return null;
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw 'Please turn on your internet connection';
    } catch (e) {
      print('Error fetching user: $e');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      return null;
    }
  }

  /// Delete Customer by customer ID
  Future<bool> deleteCustomer({
    required String userId,
    required String customerId,
  }) async {
    final Uri url = Uri.parse(ApiConstants.deleteCustomer(userId, customerId));

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        return true;
      } else {
        print('Failed to delete customer: ${response.statusCode}');
        return false;
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw 'Please turn on your internet connection';
    } catch (e) {
      print('Error deleting customer: $e');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      return false;
    }
  }

  /// Update Customer by customer ID - FIXED: Added customer wrapper
  Future<bool> updateCustomer({
    required String userId,
    required String customerId,
    required String name,
    required String email,
    required String mobile,
    required String dob,
    required String address,
    required String gender,
    required String anniversaryDate,
  }) async {
    final Uri url = Uri.parse(ApiConstants.updateCustomer(userId, customerId));

    // FIXED: Wrap in "customer" object like addCustomer
    final Map<String, dynamic> body = {"customer": {
      'name': name,
      'email': email,
      'mobile': mobile,
      'dob': dob,
      'address': address,
      'gender': gender,
      'anniversaryDate': anniversaryDate,
    }};

    try {
      print("=== UPDATE CUSTOMER DEBUG ===");
      print("User ID: $userId");
      print("Customer ID: $customerId");
      print("URL: $url");
      print("Payload: ${jsonEncode(body)}");
      
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("============================");
      
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        return true;
      } else {
        print('Failed to update customer: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw 'Please turn on your internet connection';
    } catch (e) {
      print('Error updating customer: $e');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      return false;
    }
  }
}