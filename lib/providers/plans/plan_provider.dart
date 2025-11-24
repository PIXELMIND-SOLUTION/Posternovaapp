// // // File: lib/providers/plan_provider.dart
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:posternova/helper/phone_pe_helper.dart';
// // import 'package:posternova/models/get_all_plan_model.dart';
// // import 'package:posternova/models/payment_model.dart';
// // import 'package:posternova/models/purchase_plan_model.dart';


// // class   PlanProvider extends ChangeNotifier {
// //   bool _isLoading = false;
// //   bool get isLoading => _isLoading;

// //   String? _errorMessage;
// //   String? get errorMessage => _errorMessage;
  
// //   List<GetAllPlanModel> _plans = [];
// //   List<GetAllPlanModel> get plans => _plans;
  
// //   PlanPurchaseResponseModel? _purchaseResponse;
// //   PlanPurchaseResponseModel? get purchaseResponse => _purchaseResponse;
  
// //   // Fetch all available plans
// //   Future<void> getAllPlans() async {
// //     _isLoading = true;
// //     _errorMessage = null;
// //     notifyListeners();
    
// //     try {
// //       final response = await http.get(
// //         Uri.parse('${'http://194.164.148.244:4061'}/api/plans'),
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //       );
      
// //       if (response.statusCode == 200) {
// //         final List<dynamic> data = json.decode(response.body);
// //         _plans = data.map((plan) => GetAllPlanModel.fromJson(plan)).toList();
// //       } else {
// //         _errorMessage = 'Failed to load plans: ${response.statusCode}';
// //       }
// //     } catch (e) {
// //       _errorMessage = 'Error loading plans: $e';
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }

  
// // Future<PlanPurchaseResponseModel?> purchasePlan(String userId, String planId, String transactionId) async {
// //   _isLoading = true;
// //   _errorMessage = null;
// //   _purchaseResponse = null;
// //   notifyListeners();
  
// //   try {
// //     final request = PlanPurchaseRequestModel(
// //       userId: userId,
// //       planId: planId,
// //       transactionId: transactionId, // ✅ Pass transactionId here
// //     );
    
// //     final response = await http.post(
// //       Uri.parse('${'http://194.164.148.244:4061'}/api/users/purchaseplan'),
// //       headers: {
// //         'Content-Type': 'application/json',
// //       },
// //       body: json.encode(request.toJson()),
// //     );
    
// //     if (response.statusCode == 200 || response.statusCode == 201) {
// //       final data = json.decode(response.body);
// //       _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
// //       return _purchaseResponse;
// //     } else {
// //       final errorData = json.decode(response.body);
// //       _errorMessage = errorData['message'] ?? 'Purchase failed: ${response.statusCode}';
// //       return null;
// //     }
// //   } catch (e) {
// //     _errorMessage = 'Error purchasing plan: $e';
// //     return null;
// //   } finally {
// //     _isLoading = false;
// //     notifyListeners();
// //   }
// // }


// //   // PhonePe Payment Integration - Check Payment Status
// //   Future<Map<String, dynamic>?> checkPaymentStatus(String merchantOrderId) async {
// //     _isLoading = true;
// //     _errorMessage = null;
// //     notifyListeners();
    
// //     try {
// //       final response = await http.get(
// //         Uri.parse('${'http://194.164.148.244:4061'}/api/payment/status/$merchantOrderId'),
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //       );
      
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         return data;
// //       } else {
// //         final errorData = json.decode(response.body);
// //         _errorMessage = errorData['message'] ?? 'Failed to check payment status: ${response.statusCode}';
// //         return null;
// //       }
// //     } catch (e) {
// //       _errorMessage = 'Error checking payment status: $e';
// //       return null;
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }
  
// //   // Get Purchase Details after PhonePe payment
// //   Future<PlanPurchaseResponseModel?> getPurchaseDetails(String userId, String planId) async {
// //     _isLoading = true;
// //     _errorMessage = null;
// //     _purchaseResponse = null;
// //     notifyListeners();
    
// //     try {
// //       final response = await http.get(
// //         Uri.parse('${'http://194.164.148.244:4061'}/api/users/subscription/$userId/$planId'),
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //       );
      
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
// //         return _purchaseResponse;
// //       } else {
// //         final errorData = json.decode(response.body);
// //         _errorMessage = errorData['message'] ?? 'Failed to get purchase details: ${response.statusCode}';
// //         return null;
// //       }
// //     } catch (e) {
// //       _errorMessage = 'Error fetching purchase details: $e';
// //       return null;
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }
  

// // Future<PhonePePaymentResponse> initiatePhonePePayment(String userId, String planId, String transationId)async {
// //   _isLoading = true;
// //   _errorMessage = null;
// //   notifyListeners();
  
// //   try {
// //     print('ssssssssssssssssssssssssssssssssssssssssssss$planId');
// //         print('ssssssssssssssssssssssssssssssssssssssssssss$userId');

// //     print('ssssssssssssssssssssssssssssssssssssssssssss$transationId');

// //     final response = await http.post(
// //       Uri.parse('${'http://194.164.148.244:4061'}/api/payment/phonepe'),
// //       headers: {
// //         'Content-Type': 'application/json',
// //       },
// //       body: json.encode({
// //         'userId': userId,
// //         'planId': planId,
// //         'transactionId':transationId
// //       }),
// //     );

// //        print('ressssssponse status code ${response.statusCode}');
// //         print('resssponse bodyyyyyyyyyyyyyy ${response.body}');

    
// //     if (response.statusCode == 200 || response.statusCode == 201) {
// //       final data = json.decode(response.body);
// //       await PhonePePreferenceManager.savePhonePePaymentData(PhonePePaymentResponse.fromJson(data));
// //       // Convert the raw JSON to PhonePePaymentResponse object
// //       return PhonePePaymentResponse.fromJson(data);
// //     } else {
// //       final errorData = json.decode(response.body);
// //       _errorMessage = errorData['message'] ?? 'Failed to initiate payment: ${response.statusCode}';
// //       throw Exception(_errorMessage);
// //     }
// //   } catch (e) {
// //     _errorMessage = 'Error initiating payment: $e';
// //     throw Exception(_errorMessage);
// //   } finally {
// //     _isLoading = false;
// //     notifyListeners();
// //   }
// // }

  
  
// //   void clearPurchaseResponse() {
// //     _purchaseResponse = null;
// //     notifyListeners();
// //   }
// // }















// // File: lib/providers/plan_provider.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:posternova/helper/phone_pe_helper.dart';
// import 'package:posternova/models/get_all_plan_model.dart';
// import 'package:posternova/models/payment_model.dart';
// import 'package:posternova/models/purchase_plan_model.dart';

// class PlanProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;
  
//   List<GetAllPlanModel> _plans = [];
//   List<GetAllPlanModel> get plans => _plans;
  
//   PlanPurchaseResponseModel? _purchaseResponse;
//   PlanPurchaseResponseModel? get purchaseResponse => _purchaseResponse;

//   // IAP Verification states - ADD THESE
//   bool _isVerifyingIAP = false;
//   bool get isVerifyingIAP => _isVerifyingIAP;
  
//   String? _iapVerificationMessage;
//   String? get iapVerificationMessage => _iapVerificationMessage;
  
//   bool _isIAPAvailable = false;
//   bool get isIAPAvailable => _isIAPAvailable;

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

//   Future<PlanPurchaseResponseModel?> purchasePlan(String userId, String planId, String transactionId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     _purchaseResponse = null;
//     notifyListeners();
    
//     try {
//       final request = PlanPurchaseRequestModel(
//         userId: userId,
//         planId: planId,
//         transactionId: transactionId,
//       );
      
//       final response = await http.post(
//         Uri.parse('${'http://194.164.148.244:4061'}/api/users/purchaseplan'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(request.toJson()),
//       );
      
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
//         return _purchaseResponse;
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 'Purchase failed: ${response.statusCode}';
//         return null;
//       }
//     } catch (e) {
//       _errorMessage = 'Error purchasing plan: $e';
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }


//     Future<PlanPurchaseResponseModel?> purchaseIOSPlan(String userId, String planId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     _purchaseResponse = null;
//     notifyListeners();
    
//     try {
//       final request = PlanPurchaseRequestModel(
//         userId: userId,
//         planId: planId,
//       );
//             print("REsponse body printing User.....$userId");
//                         print("REsponse body printing Plan.....$planId");


//       final response = await http.post(
//         Uri.parse('http://194.164.148.244:4061/api/payment/purchase-plan'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(request.toJson()),
//       );

//       print("REsponse body printing.....${response.body}");
      
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
//         return _purchaseResponse;
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 'Purchase failed: ${response.statusCode}';
//         return null;
//       }
//     } catch (e) {
//       _errorMessage = 'Error purchasing plan: $e';
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

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

//   // iOS In-App Purchase Verification
//   Future<Map<String, dynamic>?> verifyIosPurchase({
//     required String userId,
//     required String planId,
//     required String receiptData,
//     required String productId,
//     required String transactionId,
//   }) async {
//     _isVerifyingIAP = true;
//     _iapVerificationMessage = 'Verifying purchase...';
//     _errorMessage = null;
//     notifyListeners();
    
//     try {
//       print('Starting iOS purchase verification...');
//       print('User ID: $userId, Plan ID: $planId, Product ID: $productId');
      
//       final response = await http.post(
//         Uri.parse('${'http://194.164.148.244:4061'}/api/payment/verify-ios-purchase'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'userId': userId,
//           'planId': planId,
//           'receiptData': receiptData,
//           'productId': productId,
//           'transactionId': transactionId,
//           'platform': 'ios',
//         }),
//       );

//       print('Verification response status: ${response.statusCode}');
//       print('Verification response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
        
//         if (data['success'] == true) {
//           _iapVerificationMessage = 'Purchase verified successfully!';
//           print('iOS purchase verification successful');
          
//           // Also record the purchase in our system
//           if (data['purchaseRecorded'] == true) {
//             await purchasePlan(userId, planId, transactionId);
//           }
          
//           return {
//             'status': 'success',
//             'message': data['message'] ?? 'Purchase verified successfully',
//             'data': data
//           };
//         } else {
//           _errorMessage = data['message'] ?? 'Purchase verification failed';
//           print('iOS purchase verification failed: $_errorMessage');
//           return {
//             'status': 'failed',
//             'message': _errorMessage,
//           };
//         }
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 
//             'Verification server error: ${response.statusCode}';
//         print('Server error during verification: $_errorMessage');
//         return {
//           'status': 'error',
//           'message': _errorMessage,
//         };
//       }
//     } catch (e) {
//       _errorMessage = 'Error verifying iOS purchase: $e';
//       print('Exception during iOS purchase verification: $e');
//       return {
//         'status': 'error',
//         'message': _errorMessage,
//       };
//     } finally {
//       _isVerifyingIAP = false;
//       notifyListeners();
//     }
//   }

//   // Check IAP availability
//   Future<void> checkIAPAvailability() async {
//     try {
//       _isIAPAvailable = await InAppPurchase.instance.isAvailable();
//       notifyListeners();
//     } catch (e) {
//       _isIAPAvailable = false;
//       _errorMessage = 'Failed to check IAP availability: $e';
//       notifyListeners();
//     }
//   }

//   Future<PhonePePaymentResponse> initiatePhonePePayment(String userId, String planId, String transactionId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
    
//     try {
//       print('Initiating PhonePe payment...');
//       print('Plan ID: $planId, User ID: $userId, Transaction ID: $transactionId');

//       final response = await http.post(
//         Uri.parse('${'http://194.164.148.244:4061'}/api/payment/phonepe'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'userId': userId,
//           'planId': planId,
//           'transactionId': transactionId
//         }),
//       );

//       print('PhonePe response status code: ${response.statusCode}');
//       print('PhonePe response body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         await PhonePePreferenceManager.savePhonePePaymentData(PhonePePaymentResponse.fromJson(data));
//         return PhonePePaymentResponse.fromJson(data);
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 'Failed to initiate payment: ${response.statusCode}';
//         throw Exception(_errorMessage);
//       }
//     } catch (e) {
//       _errorMessage = 'Error initiating payment: $e';
//       throw Exception(_errorMessage);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
  
//   void clearPurchaseResponse() {
//     _purchaseResponse = null;
//     notifyListeners();
//   }

//   void clearIAPVerificationState() {
//     _isVerifyingIAP = false;
//     _iapVerificationMessage = null;
//     _errorMessage = null;
//     notifyListeners();
//   }

//   // Method to update IAP verification state
//   void setIAPVerificationState({required bool isVerifying, String? message}) {
//     _isVerifyingIAP = isVerifying;
//     _iapVerificationMessage = message;
//     notifyListeners();
//   }
// }








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















// // File: lib/providers/plan_provider.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:posternova/helper/phone_pe_helper.dart';
// import 'package:posternova/models/get_all_plan_model.dart';
// import 'package:posternova/models/payment_model.dart';
// import 'package:posternova/models/purchase_plan_model.dart';

// class PlanProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;
  
//   List<GetAllPlanModel> _plans = [];
//   List<GetAllPlanModel> get plans => _plans;
  
//   PlanPurchaseResponseModel? _purchaseResponse;
//   PlanPurchaseResponseModel? get purchaseResponse => _purchaseResponse;

//   // IAP Verification states - ADD THESE
//   bool _isVerifyingIAP = false;
//   bool get isVerifyingIAP => _isVerifyingIAP;
  
//   String? _iapVerificationMessage;
//   String? get iapVerificationMessage => _iapVerificationMessage;
  
//   bool _isIAPAvailable = false;
//   bool get isIAPAvailable => _isIAPAvailable;

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

//   Future<PlanPurchaseResponseModel?> purchasePlan(String userId, String planId, String transactionId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     _purchaseResponse = null;
//     notifyListeners();
    
//     try {
//       final request = PlanPurchaseRequestModel(
//         userId: userId,
//         planId: planId,
//         transactionId: transactionId,
//       );
      
//       final response = await http.post(
//         Uri.parse('${'http://194.164.148.244:4061'}/api/users/purchaseplan'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(request.toJson()),
//       );
      
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
//         return _purchaseResponse;
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 'Purchase failed: ${response.statusCode}';
//         return null;
//       }
//     } catch (e) {
//       _errorMessage = 'Error purchasing plan: $e';
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }


//     Future<PlanPurchaseResponseModel?> purchaseIOSPlan(String userId, String planId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     _purchaseResponse = null;
//     notifyListeners();
    
//     try {
//       final request = PlanPurchaseRequestModel(
//         userId: userId,
//         planId: planId,
//       );
//             print("REsponse body printing User.....$userId");
//                         print("REsponse body printing Plan.....$planId");


//       final response = await http.post(
//         Uri.parse('http://194.164.148.244:4061/api/payment/purchase-plan'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(request.toJson()),
//       );

//       print("REsponse body printing.....${response.body}");
      
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
//         return _purchaseResponse;
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 'Purchase failed: ${response.statusCode}';
//         return null;
//       }
//     } catch (e) {
//       _errorMessage = 'Error purchasing plan: $e';
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

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

//   // iOS In-App Purchase Verification
//   Future<Map<String, dynamic>?> verifyIosPurchase({
//     required String userId,
//     required String planId,
//     required String receiptData,
//     required String productId,
//     required String transactionId,
//   }) async {
//     _isVerifyingIAP = true;
//     _iapVerificationMessage = 'Verifying purchase...';
//     _errorMessage = null;
//     notifyListeners();
    
//     try {
//       print('Starting iOS purchase verification...');
//       print('User ID: $userId, Plan ID: $planId, Product ID: $productId');
      
//       final response = await http.post(
//         Uri.parse('${'http://194.164.148.244:4061'}/api/payment/verify-ios-purchase'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'userId': userId,
//           'planId': planId,
//           'receiptData': receiptData,
//           'productId': productId,
//           'transactionId': transactionId,
//           'platform': 'ios',
//         }),
//       );

//       print('Verification response status: ${response.statusCode}');
//       print('Verification response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
        
//         if (data['success'] == true) {
//           _iapVerificationMessage = 'Purchase verified successfully!';
//           print('iOS purchase verification successful');
          
//           // Also record the purchase in our system
//           if (data['purchaseRecorded'] == true) {
//             await purchasePlan(userId, planId, transactionId);
//           }
          
//           return {
//             'status': 'success',
//             'message': data['message'] ?? 'Purchase verified successfully',
//             'data': data
//           };
//         } else {
//           _errorMessage = data['message'] ?? 'Purchase verification failed';
//           print('iOS purchase verification failed: $_errorMessage');
//           return {
//             'status': 'failed',
//             'message': _errorMessage,
//           };
//         }
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 
//             'Verification server error: ${response.statusCode}';
//         print('Server error during verification: $_errorMessage');
//         return {
//           'status': 'error',
//           'message': _errorMessage,
//         };
//       }
//     } catch (e) {
//       _errorMessage = 'Error verifying iOS purchase: $e';
//       print('Exception during iOS purchase verification: $e');
//       return {
//         'status': 'error',
//         'message': _errorMessage,
//       };
//     } finally {
//       _isVerifyingIAP = false;
//       notifyListeners();
//     }
//   }

//   // Check IAP availability
//   Future<void> checkIAPAvailability() async {
//     try {
//       _isIAPAvailable = await InAppPurchase.instance.isAvailable();
//       notifyListeners();
//     } catch (e) {
//       _isIAPAvailable = false;
//       _errorMessage = 'Failed to check IAP availability: $e';
//       notifyListeners();
//     }
//   }

//   Future<PhonePePaymentResponse> initiatePhonePePayment(String userId, String planId, String transactionId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
    
//     try {
//       print('Initiating PhonePe payment...');
//       print('Plan ID: $planId, User ID: $userId, Transaction ID: $transactionId');

//       final response = await http.post(
//         Uri.parse('${'http://194.164.148.244:4061'}/api/payment/phonepe'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'userId': userId,
//           'planId': planId,
//           'transactionId': transactionId
//         }),
//       );

//       print('PhonePe response status code: ${response.statusCode}');
//       print('PhonePe response body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         await PhonePePreferenceManager.savePhonePePaymentData(PhonePePaymentResponse.fromJson(data));
//         return PhonePePaymentResponse.fromJson(data);
//       } else {
//         final errorData = json.decode(response.body);
//         _errorMessage = errorData['message'] ?? 'Failed to initiate payment: ${response.statusCode}';
//         throw Exception(_errorMessage);
//       }
//     } catch (e) {
//       _errorMessage = 'Error initiating payment: $e';
//       throw Exception(_errorMessage);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
  
//   void clearPurchaseResponse() {
//     _purchaseResponse = null;
//     notifyListeners();
//   }

//   void clearIAPVerificationState() {
//     _isVerifyingIAP = false;
//     _iapVerificationMessage = null;
//     _errorMessage = null;
//     notifyListeners();
//   }

//   // Method to update IAP verification state
//   void setIAPVerificationState({required bool isVerifying, String? message}) {
//     _isVerifyingIAP = isVerifying;
//     _iapVerificationMessage = message;
//     notifyListeners();
//   }
// }


















// // lib/providers/plan_provider.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:posternova/models/get_all_plan_model.dart';
// import 'package:posternova/models/purchase_plan_model.dart';
// import 'package:posternova/models/payment_model.dart';
// import 'package:posternova/helper/phone_pe_helper.dart';

// /// PlanProvider - manages fetching plans, purchasing and iOS IAP verification.
// ///
// /// Make sure required models exist:
// /// - GetAllPlanModel.fromJson
// /// - PlanPurchaseRequestModel / PlanPurchaseResponseModel
// /// - PhonePePaymentResponse.fromJson
// class PlanProvider extends ChangeNotifier {
//   // === configuration ===
//   final String _baseUrl = 'http://194.164.148.244:4061';

//   // === loading / error states ===
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   // === plans list ===
//   List<GetAllPlanModel> _plans = [];
//   List<GetAllPlanModel> get plans => _plans;

//   // === purchase response ===
//   PlanPurchaseResponseModel? _purchaseResponse;
//   PlanPurchaseResponseModel? get purchaseResponse => _purchaseResponse;

//   // === IAP verification states ===
//   bool _isVerifyingIAP = false;
//   bool get isVerifyingIAP => _isVerifyingIAP;

//   String? _iapVerificationMessage;
//   String? get iapVerificationMessage => _iapVerificationMessage;

//   bool _isIAPAvailable = false;
//   bool get isIAPAvailable => _isIAPAvailable;

//   // === constructor ===
//   PlanProvider();

//   // === helpers ===
//   void _setLoading(bool v) {
//     _isLoading = v;
//     notifyListeners();
//   }

//   void _setError(String? msg) {
//     _errorMessage = msg;
//     notifyListeners();
//   }

//   void _setIAPVerifying(bool value, {String? message}) {
//     _isVerifyingIAP = value;
//     _iapVerificationMessage = message;
//     notifyListeners();
//   }

//   // ======================
//   // ==== Public API ======
//   // ======================

//   /// Fetch all plans
//   Future<void> getAllPlans() async {
//     _setLoading(true);
//     _setError(null);

//     try {
//       final url = Uri.parse('$_baseUrl/api/plans');
//       final response = await http.get(
//         url,
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         _plans = data.map((p) => GetAllPlanModel.fromJson(p)).toList();
//       } else {
//         _setError('Failed to load plans: ${response.statusCode}');
//       }
//     } catch (e) {
//       _setError('Error loading plans: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   /// Generic purchasePlan that uses your payments API to record the purchase in your DB.
//   /// This is used after backend verifies the payment (or for server-side payments).
//   Future<PlanPurchaseResponseModel?> purchasePlan(String userId, String planId, String transactionId) async {
//     _setLoading(true);
//     _setError(null);
//     _purchaseResponse = null;

//     try {
//       final request = PlanPurchaseRequestModel(
//         userId: userId,
//         planId: planId,
//         transactionId: transactionId,
//       );

//       // Print outgoing body for debugging (as requested)
//       final requestBody = json.encode(request.toJson());
//       debugPrint('[purchasePlan] POST $_baseUrl/api/users/purchaseplan');
//       debugPrint('[purchasePlan] Body: $requestBody');

//       final response = await http.post(
//         Uri.parse('$_baseUrl/api/users/purchaseplan'),
//         headers: {'Content-Type': 'application/json'},
//         body: requestBody,
//       );

//       debugPrint('[purchasePlan] Status: ${response.statusCode}');
//       debugPrint('[purchasePlan] Response: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
//         return _purchaseResponse;
//       } else {
//         final errorData = _safeDecode(response.body);
//         _setError(errorData['message'] ?? 'Purchase failed: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       _setError('Error purchasing plan: $e');
//       return null;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   /// Initiates PhonePe payment (Android flow)
//   Future<PhonePePaymentResponse> initiatePhonePePayment(String userId, String planId, String transactionId) async {
//     _setLoading(true);
//     _setError(null);

//     try {
//       final body = {
//         'userId': userId,
//         'planId': planId,
//         'transactionId': transactionId,
//       };

//       debugPrint('[initiatePhonePePayment] POST $_baseUrl/api/payment/phonepe');
//       debugPrint('[initiatePhonePePayment] Body: ${json.encode(body)}');

//       final response = await http.post(
//         Uri.parse('$_baseUrl/api/payment/phonepe'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(body),
//       );

//       debugPrint('[initiatePhonePePayment] Status: ${response.statusCode}');
//       debugPrint('[initiatePhonePePayment] Response: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         final phonePeResp = PhonePePaymentResponse.fromJson(data);
//         await PhonePePreferenceManager.savePhonePePaymentData(phonePeResp);
//         return phonePeResp;
//       } else {
//         final err = _safeDecode(response.body);
//         _setError(err['message'] ?? 'Failed to initiate payment: ${response.statusCode}');
//         throw Exception(_errorMessage);
//       }
//     } catch (e) {
//       _setError('Error initiating payment: $e');
//       throw Exception(_errorMessage ?? e.toString());
//     } finally {
//       _setLoading(false);
//     }
//   }

//   /// Check PhonePe payment status (optional helper)
//   Future<Map<String, dynamic>?> checkPaymentStatus(String merchantOrderId) async {
//     _setLoading(true);
//     _setError(null);

//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/api/payment/status/$merchantOrderId'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       debugPrint('[checkPaymentStatus] Status: ${response.statusCode}');
//       debugPrint('[checkPaymentStatus] Response: ${response.body}');

//       if (response.statusCode == 200) {
//         return json.decode(response.body) as Map<String, dynamic>;
//       } else {
//         final err = _safeDecode(response.body);
//         _setError(err['message'] ?? 'Failed to check payment status: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       _setError('Error checking payment status: $e');
//       return null;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   /// Get purchase/subscription details for a user
//   Future<PlanPurchaseResponseModel?> getPurchaseDetails(String userId, String planId) async {
//     _setLoading(true);
//     _setError(null);
//     _purchaseResponse = null;

//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/api/users/subscription/$userId/$planId'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       debugPrint('[getPurchaseDetails] Status: ${response.statusCode}');
//       debugPrint('[getPurchaseDetails] Response: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
//         return _purchaseResponse;
//       } else {
//         final err = _safeDecode(response.body);
//         _setError(err['message'] ?? 'Failed to get purchase details: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       _setError('Error fetching purchase details: $e');
//       return null;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // ================================
//   // ===== iOS IAP verification =====
//   // ================================

//   /// Verifies iOS purchase with backend (recommended).
//   ///
//   /// Backend should validate receipt with Apple servers, and only if valid should
//   /// record the purchase (e.g. grant subscription / store in DB).
//   ///
//   /// Required params:
//   /// - userId: app user id
//   /// - planId: internal plan id
//   /// - receiptData: base64 receipt (from StoreKit)
//   /// - productId: product id string
//   /// - transactionId: transaction id returned by StoreKit
//   Future<Map<String, dynamic>?> verifyIosPurchase({
//     required String userId,
//     required String planId,
//     required String receiptData,
//     required String productId,
//     required String transactionId,
//   }) async {
//     _setIAPVerifying(true, message: 'Verifying purchase...');
//     _setError(null);

//     try {
//       final body = {
//         'userId': userId,
//         'planId': planId,
//         'receiptData': receiptData,
//         'productId': productId,
//         'transactionId': transactionId,
//         'platform': 'ios',
//       };

//       // Print outgoing body for debugging (but don't log raw receipt in production)
//       debugPrint('[verifyIosPurchase] POST $_baseUrl/api/payment/apple/pay');
//       debugPrint('[verifyIosPurchase] Body (truncated receipt): ${_truncateForLog(json.encode(body), 200)}');

//       final response = await http.post(
//         Uri.parse('$_baseUrl/api/payment/apple/pay'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(body),
//       );

//       debugPrint('[verifyIosPurchase] Status: ${response.statusCode}');
//       debugPrint('[verifyIosPurchase] Response: ${response.body}');

//       final respJson = _safeDecode(response.body);
//       // if (response.statusCode == 200) {
//         if (respJson['success'] == true) {
//           _iapVerificationMessage = respJson['message'] ?? 'Purchase verified successfully';

//           // If backend indicates purchase was recorded already, optionally fetch purchase details
//           if (respJson['purchaseRecorded'] == true) {
//             // Optionally record locally by calling purchasePlan or getPurchaseDetails
//             await purchasePlan(userId, planId, transactionId);
//           }

//      return {
//   'success': true,
//   'message': respJson['message'],
//   'subscription': respJson['subscription'],
//   'transactionId': respJson['transactionId'],
// };

//         } else {
// return {'success': false, 'message': respJson['message']};
//         }
//       // } else {
//       //   _setError(respJson['message'] ?? 'Verification server error: ${response.statusCode}');
//       //   return {'status': 'error', 'message': _errorMessage};
//       // }
//     } catch (e) {
//       _setError('Error verifying iOS purchase: $e');
//       return {'status': 'error', 'message': _errorMessage};
//     } finally {
//       _setIAPVerifying(false);
//     }
//   }

//   /// Shortcut helper used by UI after an iOS purchase to send the receipt etc.
//   /// It prints the data (as requested) and calls backend verify.
//   Future<Map<String, dynamic>?> purchaseIOSPlan({
//     required String userId,
//     required String planId,
//     required String receiptData,
//     required String productId,
//     required String transactionId,
//   }) async {
//     // Print the data that will be sent to backend
//     debugPrint('=== purchaseIOSPlan - preparing to call backend ===');
//     debugPrint('UserId: $userId');
//     debugPrint('PlanId: $planId');
//     debugPrint('ProductId: $productId');
//     debugPrint('TransactionId: $transactionId');
//     debugPrint('Receipt (truncated): ${_truncateForLog(receiptData, 200)}');

//     final verifyResult = await verifyIosPurchase(
//       userId: userId,
//       planId: planId,
//       receiptData: receiptData,
//       productId: productId,
//       transactionId: transactionId,
//     );

//     return verifyResult;
//   }

//   // =========================
//   // ==== IAP availability ===
//   // =========================
//   Future<void> checkIAPAvailability() async {
//     try {
//       _isIAPAvailable = await InAppPurchase.instance.isAvailable();
//       notifyListeners();
//     } catch (e) {
//       _isIAPAvailable = false;
//       _setError('Failed to check IAP availability: $e');
//     }
//   }

//   // =========================
//   // === utility functions ===
//   // =========================

//   /// Small helper which safely decodes JSON or returns empty map
//   Map<String, dynamic> _safeDecode(String body) {
//     try {
//       final decoded = json.decode(body);
//       if (decoded is Map<String, dynamic>) return decoded;
//       return {'data': decoded};
//     } catch (_) {
//       return {'message': body};
//     }
//   }

//   /// Truncate string for logs (don't log huge receipts)
//   String _truncateForLog(String input, int maxLen) {
//     if (input.length <= maxLen) return input;
//     return input.substring(0, maxLen) + '... (truncated)';
//   }

//   /// Clear purchase response cached
//   void clearPurchaseResponse() {
//     _purchaseResponse = null;
//     notifyListeners();
//   }

//   /// Clear verification state
//   void clearIAPVerificationState() {
//     _isVerifyingIAP = false;
//     _iapVerificationMessage = null;
//     _errorMessage = null;
//     notifyListeners();
//   }

//   /// Update IAP verification state externally
//   void setIAPVerificationState({required bool isVerifying, String? message}) {
//     _isVerifyingIAP = isVerifying;
//     _iapVerificationMessage = message;
//     notifyListeners();
//   }
// }



















// lib/providers/plan_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:posternova/models/get_all_plan_model.dart';
import 'package:posternova/models/purchase_plan_model.dart';
import 'package:posternova/models/payment_model.dart';
import 'package:posternova/helper/phone_pe_helper.dart';

/// PlanProvider - manages fetching plans, purchasing and iOS IAP verification.
///
/// Make sure required models exist:
/// - GetAllPlanModel.fromJson
/// - PlanPurchaseRequestModel / PlanPurchaseResponseModel
/// - PhonePePaymentResponse.fromJson
class PlanProvider extends ChangeNotifier {
  // === configuration ===
  final String _baseUrl = 'http://194.164.148.244:4061';

  // === loading / error states ===
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // === plans list ===
  List<GetAllPlanModel> _plans = [];
  List<GetAllPlanModel> get plans => _plans;

  // === purchase response ===
  PlanPurchaseResponseModel? _purchaseResponse;
  PlanPurchaseResponseModel? get purchaseResponse => _purchaseResponse;

  // === IAP verification states ===
  bool _isVerifyingIAP = false;
  bool get isVerifyingIAP => _isVerifyingIAP;

  String? _iapVerificationMessage;
  String? get iapVerificationMessage => _iapVerificationMessage;

  bool _isIAPAvailable = false;
  bool get isIAPAvailable => _isIAPAvailable;

  // === constructor ===
  PlanProvider();

  // === helpers ===
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _setIAPVerifying(bool value, {String? message}) {
    _isVerifyingIAP = value;
    _iapVerificationMessage = message;
    notifyListeners();
  }

  // ======================
  // ==== Public API ======
  // ======================

  /// Fetch all plans
  Future<void> getAllPlans() async {
    _setLoading(true);
    _setError(null);

    try {
      final url = Uri.parse('$_baseUrl/api/plans');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _plans = data.map((p) => GetAllPlanModel.fromJson(p)).toList();
      } else {
        _setError('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Error loading plans: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Generic purchasePlan that uses your payments API to record the purchase in your DB.
  /// This is used after backend verifies the payment (or for server-side payments).
  Future<PlanPurchaseResponseModel?> purchasePlan(String userId, String planId, String transactionId) async {
    _setLoading(true);
    _setError(null);
    _purchaseResponse = null;

    try {
      final request = PlanPurchaseRequestModel(
        userId: userId,
        planId: planId,
        transactionId: transactionId,
      );

      // Print outgoing body for debugging (as requested)
      final requestBody = json.encode(request.toJson());
      debugPrint('[purchasePlan] POST $_baseUrl/api/users/purchaseplan');
      debugPrint('[purchasePlan] Body: $requestBody');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/users/purchaseplan'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      debugPrint('[purchasePlan] Status: ${response.statusCode}');
      debugPrint('[purchasePlan] Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
        return _purchaseResponse;
      } else {
        final errorData = _safeDecode(response.body);
        _setError(errorData['message'] ?? 'Purchase failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _setError('Error purchasing plan: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Initiates PhonePe payment (Android flow)
  Future<PhonePePaymentResponse> initiatePhonePePayment(String userId, String planId, String transactionId) async {
    _setLoading(true);
    _setError(null);

    try {
      final body = {
        'userId': userId,
        'planId': planId,
        'transactionId': transactionId,
      };

      debugPrint('[initiatePhonePePayment] POST $_baseUrl/api/payment/phonepe');
      debugPrint('[initiatePhonePePayment] Body: ${json.encode(body)}');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/payment/phonepe'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      debugPrint('[initiatePhonePePayment] Status: ${response.statusCode}');
      debugPrint('[initiatePhonePePayment] Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final phonePeResp = PhonePePaymentResponse.fromJson(data);
        await PhonePePreferenceManager.savePhonePePaymentData(phonePeResp);
        return phonePeResp;
      } else {
        final err = _safeDecode(response.body);
        _setError(err['message'] ?? 'Failed to initiate payment: ${response.statusCode}');
        throw Exception(_errorMessage);
      }
    } catch (e) {
      _setError('Error initiating payment: $e');
      throw Exception(_errorMessage ?? e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Check PhonePe payment status (optional helper)
  Future<Map<String, dynamic>?> checkPaymentStatus(String merchantOrderId) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/payment/status/$merchantOrderId'),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('[checkPaymentStatus] Status: ${response.statusCode}');
      debugPrint('[checkPaymentStatus] Response: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final err = _safeDecode(response.body);
        _setError(err['message'] ?? 'Failed to check payment status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _setError('Error checking payment status: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Get purchase/subscription details for a user
  Future<PlanPurchaseResponseModel?> getPurchaseDetails(String userId, String planId) async {
    _setLoading(true);
    _setError(null);
    _purchaseResponse = null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/subscription/$userId/$planId'),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('[getPurchaseDetails] Status: ${response.statusCode}');
      debugPrint('[getPurchaseDetails] Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _purchaseResponse = PlanPurchaseResponseModel.fromJson(data);
        return _purchaseResponse;
      } else {
        final err = _safeDecode(response.body);
        _setError(err['message'] ?? 'Failed to get purchase details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _setError('Error fetching purchase details: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ================================
  // ===== iOS IAP verification =====
  // ================================

  /// Verifies iOS purchase with backend (recommended).
  ///
  /// Backend should validate receipt with Apple servers, and only if valid should
  /// record the purchase (e.g. grant subscription / store in DB).
  ///
  /// Required params:
  /// - userId: app user id
  /// - planId: internal plan id
  /// - receiptData: base64 receipt (from StoreKit)
  /// - productId: product id string
  /// - transactionId: transaction id returned by StoreKit
  Future<Map<String, dynamic>?> verifyIosPurchase({
    required String userId,
    required String planId,
    required String receiptData,
    required String productId,
    required String transactionId,
  }) async {
    _setIAPVerifying(true, message: 'Verifying purchase...');
    _setError(null);

    try {
      final body = {
        'userId': userId,
        'planId': planId,
        'receiptData': receiptData,
        'productId': productId,
        'transactionId': transactionId,
        'platform': 'ios',
      };

      // Print outgoing body for debugging (but don't log raw receipt in production)
      debugPrint('[verifyIosPurchase] POST $_baseUrl/api/payment/apple/pay');
      debugPrint('[verifyIosPurchase] Body (truncated receipt): ${_truncateForLog(json.encode(body), 200)}');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/payment/apple/pay'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      debugPrint('[verifyIosPurchase] Status: ${response.statusCode}');
      debugPrint('[verifyIosPurchase] Response: ${response.body}');

      final respJson = _safeDecode(response.body);
      // if (response.statusCode == 200) {
        if (respJson['success'] == true) {
          _iapVerificationMessage = respJson['message'] ?? 'Purchase verified successfully';

          // If backend indicates purchase was recorded already, optionally fetch purchase details
          if (respJson['purchaseRecorded'] == true) {
            // Optionally record locally by calling purchasePlan or getPurchaseDetails
            await purchasePlan(userId, planId, transactionId);
          }
                print("111111111111$_errorMessage");

     return {
  'success': true,
  'message': respJson['message'],
  'subscription': respJson['subscription'],
  'transactionId': respJson['transactionId'],
};

        } else {
                print("66666666666666666666666666666666${respJson['message']}");

return {'success': false, 'message': respJson['message']};
        }
      // } else {
      //   _setError(respJson['message'] ?? 'Verification server error: ${response.statusCode}');
      //   return {'status': 'error', 'message': _errorMessage};
      // }
    } catch (e) {
      print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj$_errorMessage");
      _setError('Error verifying iOS purchase: $e');
      return {'status': 'error', 'message': _errorMessage};
    } finally {
      _setIAPVerifying(false);
    }
  }

  /// Shortcut helper used by UI after an iOS purchase to send the receipt etc.
  /// It prints the data (as requested) and calls backend verify.
  Future<Map<String, dynamic>?> purchaseIOSPlan({
    required String userId,
    required String planId,
    required String receiptData,
    required String productId,
    required String transactionId,
  }) async {
    // Print the data that will be sent to backend
    debugPrint('=== purchaseIOSPlan - preparing to call backend ===');
    debugPrint('UserId: $userId');
    debugPrint('PlanId: $planId');
    debugPrint('ProductId: $productId');
    debugPrint('TransactionId: $transactionId');
    debugPrint('Receipt (truncated): ${_truncateForLog(receiptData, 200)}');

    final verifyResult = await verifyIosPurchase(
      userId: userId,
      planId: planId,
      receiptData: receiptData,
      productId: productId,
      transactionId: transactionId,
    );

    return verifyResult;
  }

  // =========================
  // ==== IAP availability ===
  // =========================
  Future<void> checkIAPAvailability() async {
    try {
      _isIAPAvailable = await InAppPurchase.instance.isAvailable();
      notifyListeners();
    } catch (e) {
      _isIAPAvailable = false;
      _setError('Failed to check IAP availability: $e');
    }
  }

  // =========================
  // === utility functions ===
  // =========================

  /// Small helper which safely decodes JSON or returns empty map
  Map<String, dynamic> _safeDecode(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } catch (_) {
      return {'message': body};
    }
  }

  /// Truncate string for logs (don't log huge receipts)
  String _truncateForLog(String input, int maxLen) {
    if (input.length <= maxLen) return input;
    return input.substring(0, maxLen) + '... (truncated)';
  }

  /// Clear purchase response cached
  void clearPurchaseResponse() {
    _purchaseResponse = null;
    notifyListeners();
  }

  /// Clear verification state
  void clearIAPVerificationState() {
    _isVerifyingIAP = false;
    _iapVerificationMessage = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Update IAP verification state externally
  void setIAPVerificationState({required bool isVerifying, String? message}) {
    _isVerifyingIAP = isVerifying;
    _iapVerificationMessage = message;
    notifyListeners();
  }
}
