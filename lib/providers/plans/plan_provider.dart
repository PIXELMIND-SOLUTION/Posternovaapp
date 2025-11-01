// File: lib/providers/plan_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/phone_pe_helper.dart';
import 'package:posternova/models/get_all_plan_model.dart';
import 'package:posternova/models/payment_model.dart';
import 'package:posternova/models/purchase_plan_model.dart';


class   PlanProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  List<GetAllPlanModel> _plans = [];
  List<GetAllPlanModel> get plans => _plans;
  
  PlanPurchaseResponseModel? _purchaseResponse;
  PlanPurchaseResponseModel? get purchaseResponse => _purchaseResponse;
  
  // Fetch all available plans
  Future<void> getAllPlans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await http.get(
        Uri.parse('${'http://194.164.148.244:4061'}/api/plans'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _plans = data.map((plan) => GetAllPlanModel.fromJson(plan)).toList();
      } else {
        _errorMessage = 'Failed to load plans: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error loading plans: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
Future<PlanPurchaseResponseModel?> purchasePlan(String userId, String planId, String transactionId) async {
  _isLoading = true;
  _errorMessage = null;
  _purchaseResponse = null;
  notifyListeners();
  
  try {
    final request = PlanPurchaseRequestModel(
      userId: userId,
      planId: planId,
      transactionId: transactionId, // ✅ Pass transactionId here
    );
    
    final response = await http.post(
      Uri.parse('${'http://194.164.148.244:4061'}/api/users/purchaseplan'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
      return _purchaseResponse;
    } else {
      final errorData = json.decode(response.body);
      _errorMessage = errorData['message'] ?? 'Purchase failed: ${response.statusCode}';
      return null;
    }
  } catch (e) {
    _errorMessage = 'Error purchasing plan: $e';
    return null;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  // PhonePe Payment Integration - Check Payment Status
  Future<Map<String, dynamic>?> checkPaymentStatus(String merchantOrderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await http.get(
        Uri.parse('${'http://194.164.148.244:4061'}/api/payment/status/$merchantOrderId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['message'] ?? 'Failed to check payment status: ${response.statusCode}';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Error checking payment status: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get Purchase Details after PhonePe payment
  Future<PlanPurchaseResponseModel?> getPurchaseDetails(String userId, String planId) async {
    _isLoading = true;
    _errorMessage = null;
    _purchaseResponse = null;
    notifyListeners();
    
    try {
      final response = await http.get(
        Uri.parse('${'http://194.164.148.244:4061'}/api/users/subscription/$userId/$planId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
        return _purchaseResponse;
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['message'] ?? 'Failed to get purchase details: ${response.statusCode}';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Error fetching purchase details: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  

Future<PhonePePaymentResponse> initiatePhonePePayment(String userId, String planId, String transationId)async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();
  
  try {
    print('ssssssssssssssssssssssssssssssssssssssssssss$planId');
        print('ssssssssssssssssssssssssssssssssssssssssssss$userId');

    print('ssssssssssssssssssssssssssssssssssssssssssss$transationId');

    final response = await http.post(
      Uri.parse('${'http://194.164.148.244:4061'}/api/payment/phonepe'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userId': userId,
        'planId': planId,
        'transactionId':transationId
      }),
    );

       print('ressssssponse status code ${response.statusCode}');
        print('resssponse bodyyyyyyyyyyyyyy ${response.body}');

    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      await PhonePePreferenceManager.savePhonePePaymentData(PhonePePaymentResponse.fromJson(data));
      // Convert the raw JSON to PhonePePaymentResponse object
      return PhonePePaymentResponse.fromJson(data);
    } else {
      final errorData = json.decode(response.body);
      _errorMessage = errorData['message'] ?? 'Failed to initiate payment: ${response.statusCode}';
      throw Exception(_errorMessage);
    }
  } catch (e) {
    _errorMessage = 'Error initiating payment: $e';
    throw Exception(_errorMessage);
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  
  
  void clearPurchaseResponse() {
    _purchaseResponse = null;
    notifyListeners();
  }
}