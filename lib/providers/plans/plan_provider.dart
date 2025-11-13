// // File: lib/providers/plan_provider.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:posternova/helper/phone_pe_helper.dart';
// import 'package:posternova/models/get_all_plan_model.dart';
// import 'package:posternova/models/payment_model.dart';
// import 'package:posternova/models/purchase_plan_model.dart';


// class   PlanProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;
  
//   List<GetAllPlanModel> _plans = [];
//   List<GetAllPlanModel> get plans => _plans;
  
//   PlanPurchaseResponseModel? _purchaseResponse;
//   PlanPurchaseResponseModel? get purchaseResponse => _purchaseResponse;
  
//   // Fetch all available plans
//   Future<void> getAllPlans() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
    
//     try {
//       final response = await http.get(
//         Uri.parse('${'http://194.164.148.244:4061'}/api/plans'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
      
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         _plans = data.map((plan) => GetAllPlanModel.fromJson(plan)).toList();
//       } else {
//         _errorMessage = 'Failed to load plans: ${response.statusCode}';
//       }
//     } catch (e) {
//       _errorMessage = 'Error loading plans: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

  
// Future<PlanPurchaseResponseModel?> purchasePlan(String userId, String planId, String transactionId) async {
//   _isLoading = true;
//   _errorMessage = null;
//   _purchaseResponse = null;
//   notifyListeners();
  
//   try {
//     final request = PlanPurchaseRequestModel(
//       userId: userId,
//       planId: planId,
//       transactionId: transactionId, // ✅ Pass transactionId here
//     );
    
//     final response = await http.post(
//       Uri.parse('${'http://194.164.148.244:4061'}/api/users/purchaseplan'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(request.toJson()),
//     );
    
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = json.decode(response.body);
//       _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
//       return _purchaseResponse;
//     } else {
//       final errorData = json.decode(response.body);
//       _errorMessage = errorData['message'] ?? 'Purchase failed: ${response.statusCode}';
//       return null;
//     }
//   } catch (e) {
//     _errorMessage = 'Error purchasing plan: $e';
//     return null;
//   } finally {
//     _isLoading = false;
//     notifyListeners();
//   }
// }


//   // PhonePe Payment Integration - Check Payment Status
//   Future<Map<String, dynamic>?> checkPaymentStatus(String merchantOrderId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
    
//     try {
//       final response = await http.get(
//         Uri.parse('${'http://194.164.148.244:4061'}/api/payment/status/$merchantOrderId'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
      
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data;
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 'Failed to check payment status: ${response.statusCode}';
//         return null;
//       }
//     } catch (e) {
//       _errorMessage = 'Error checking payment status: $e';
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
  
//   // Get Purchase Details after PhonePe payment
//   Future<PlanPurchaseResponseModel?> getPurchaseDetails(String userId, String planId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     _purchaseResponse = null;
//     notifyListeners();
    
//     try {
//       final response = await http.get(
//         Uri.parse('${'http://194.164.148.244:4061'}/api/users/subscription/$userId/$planId'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
      
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
//         return _purchaseResponse;
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 'Failed to get purchase details: ${response.statusCode}';
//         return null;
//       }
//     } catch (e) {
//       _errorMessage = 'Error fetching purchase details: $e';
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
  

// Future<PhonePePaymentResponse> initiatePhonePePayment(String userId, String planId, String transationId)async {
//   _isLoading = true;
//   _errorMessage = null;
//   notifyListeners();
  
//   try {
//     print('ssssssssssssssssssssssssssssssssssssssssssss$planId');
//         print('ssssssssssssssssssssssssssssssssssssssssssss$userId');

//     print('ssssssssssssssssssssssssssssssssssssssssssss$transationId');

//     final response = await http.post(
//       Uri.parse('${'http://194.164.148.244:4061'}/api/payment/phonepe'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'userId': userId,
//         'planId': planId,
//         'transactionId':transationId
//       }),
//     );

//        print('ressssssponse status code ${response.statusCode}');
//         print('resssponse bodyyyyyyyyyyyyyy ${response.body}');

    
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = json.decode(response.body);
//       await PhonePePreferenceManager.savePhonePePaymentData(PhonePePaymentResponse.fromJson(data));
//       // Convert the raw JSON to PhonePePaymentResponse object
//       return PhonePePaymentResponse.fromJson(data);
//     } else {
//       final errorData = json.decode(response.body);
//       _errorMessage = errorData['message'] ?? 'Failed to initiate payment: ${response.statusCode}';
//       throw Exception(_errorMessage);
//     }
//   } catch (e) {
//     _errorMessage = 'Error initiating payment: $e';
//     throw Exception(_errorMessage);
//   } finally {
//     _isLoading = false;
//     notifyListeners();
//   }
// }

  
  
//   void clearPurchaseResponse() {
//     _purchaseResponse = null;
//     notifyListeners();
//   }
// }















// File: lib/providers/plan_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:posternova/helper/phone_pe_helper.dart';
import 'package:posternova/models/get_all_plan_model.dart';
import 'package:posternova/models/payment_model.dart';
import 'package:posternova/models/purchase_plan_model.dart';

class PlanProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  List<GetAllPlanModel> _plans = [];
  List<GetAllPlanModel> get plans => _plans;
  
  PlanPurchaseResponseModel? _purchaseResponse;
  PlanPurchaseResponseModel? get purchaseResponse => _purchaseResponse;

  // IAP Verification states - ADD THESE
  bool _isVerifyingIAP = false;
  bool get isVerifyingIAP => _isVerifyingIAP;
  
  String? _iapVerificationMessage;
  String? get iapVerificationMessage => _iapVerificationMessage;
  
  bool _isIAPAvailable = false;
  bool get isIAPAvailable => _isIAPAvailable;

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
        transactionId: transactionId,
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


    Future<PlanPurchaseResponseModel?> purchaseIOSPlan(String userId, String planId) async {
    _isLoading = true;
    _errorMessage = null;
    _purchaseResponse = null;
    notifyListeners();
    
    try {
      final request = PlanPurchaseRequestModel(
        userId: userId,
        planId: planId,
      );
            print("REsponse body printing User.....$userId");
                        print("REsponse body printing Plan.....$planId");


      final response = await http.post(
        Uri.parse('http://194.164.148.244:4061/api/payment/purchase-plan'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print("REsponse body printing.....${response.body}");
      
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

  // iOS In-App Purchase Verification
  Future<Map<String, dynamic>?> verifyIosPurchase({
    required String userId,
    required String planId,
    required String receiptData,
    required String productId,
    required String transactionId,
  }) async {
    _isVerifyingIAP = true;
    _iapVerificationMessage = 'Verifying purchase...';
    _errorMessage = null;
    notifyListeners();
    
    try {
      print('Starting iOS purchase verification...');
      print('User ID: $userId, Plan ID: $planId, Product ID: $productId');
      
      final response = await http.post(
        Uri.parse('${'http://194.164.148.244:4061'}/api/payment/verify-ios-purchase'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'planId': planId,
          'receiptData': receiptData,
          'productId': productId,
          'transactionId': transactionId,
          'platform': 'ios',
        }),
      );

      print('Verification response status: ${response.statusCode}');
      print('Verification response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          _iapVerificationMessage = 'Purchase verified successfully!';
          print('iOS purchase verification successful');
          
          // Also record the purchase in our system
          if (data['purchaseRecorded'] == true) {
            await purchasePlan(userId, planId, transactionId);
          }
          
          return {
            'status': 'success',
            'message': data['message'] ?? 'Purchase verified successfully',
            'data': data
          };
        } else {
          _errorMessage = data['message'] ?? 'Purchase verification failed';
          print('iOS purchase verification failed: $_errorMessage');
          return {
            'status': 'failed',
            'message': _errorMessage,
          };
        }
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['message'] ?? 
            'Verification server error: ${response.statusCode}';
        print('Server error during verification: $_errorMessage');
        return {
          'status': 'error',
          'message': _errorMessage,
        };
      }
    } catch (e) {
      _errorMessage = 'Error verifying iOS purchase: $e';
      print('Exception during iOS purchase verification: $e');
      return {
        'status': 'error',
        'message': _errorMessage,
      };
    } finally {
      _isVerifyingIAP = false;
      notifyListeners();
    }
  }

  // Check IAP availability
  Future<void> checkIAPAvailability() async {
    try {
      _isIAPAvailable = await InAppPurchase.instance.isAvailable();
      notifyListeners();
    } catch (e) {
      _isIAPAvailable = false;
      _errorMessage = 'Failed to check IAP availability: $e';
      notifyListeners();
    }
  }

  Future<PhonePePaymentResponse> initiatePhonePePayment(String userId, String planId, String transactionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      print('Initiating PhonePe payment...');
      print('Plan ID: $planId, User ID: $userId, Transaction ID: $transactionId');

      final response = await http.post(
        Uri.parse('${'http://194.164.148.244:4061'}/api/payment/phonepe'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'planId': planId,
          'transactionId': transactionId
        }),
      );

      print('PhonePe response status code: ${response.statusCode}');
      print('PhonePe response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        await PhonePePreferenceManager.savePhonePePaymentData(PhonePePaymentResponse.fromJson(data));
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

  void clearIAPVerificationState() {
    _isVerifyingIAP = false;
    _iapVerificationMessage = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Method to update IAP verification state
  void setIAPVerificationState({required bool isVerifying, String? message}) {
    _isVerifyingIAP = isVerifying;
    _iapVerificationMessage = message;
    notifyListeners();
  }
}