
// import 'package:flutter/material.dart';
// import 'package:posternova/models/register_model.dart';
// import 'package:posternova/services/auth/register_service.dart';

// class SignupProvider extends ChangeNotifier {
//   final SignupServices _signupServices = SignupServices();

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   Future<bool> registerUser(SignupModel signupModel) async {
//     _setLoading(true);
//     try {
//       final success = await _signupServices.registerUser(signupModel);
//       if (success) {
//         _errorMessage = null;
//         _setLoading(false);
//         return true;
//       } else {
//         _errorMessage = 'Registration failed. Please try again.';
//         _setLoading(false);
//         return false;
//       }
//     } catch (e) {
//       _errorMessage = 'An error occurred: $e';
//       _setLoading(false);
//       return false;
//     }
//   }

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
// }


















import 'package:flutter/material.dart';
import 'package:posternova/models/register_model.dart';
import 'package:posternova/services/FCM/fcm_service.dart';
import 'package:posternova/services/auth/register_service.dart';

class SignupProvider extends ChangeNotifier {
  final SignupServices _signupServices = SignupServices();
  final FCMService _fcmService = FCMService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> registerUser(SignupModel signupModel) async {
    _setLoading(true);
    try {
      // Get FCM token
      String? fcmToken = _fcmService.fcmToken;
      
      // If token is not available, try to get it
      if (fcmToken == null || fcmToken.isEmpty) {
        print('FCM token not found in SignupProvider, fetching...');
        fcmToken = await _fcmService.getFCMToken();
      }

      // Use a default token if FCM is not available (for testing/development)
      fcmToken ??= 'default_fcm_token';

      print('Registering user with FCM Token: $fcmToken');

      // Update the signup model with FCM token
      final updatedSignupModel = SignupModel(
        id: signupModel.id,
        name: signupModel.name,
        email: signupModel.email,
        mobile: signupModel.mobile,
        dob: signupModel.dob,
        marriageAnniversary: signupModel.marriageAnniversary,
        referralCode: signupModel.referralCode,
        fcmtoken: fcmToken,
      );

      final success = await _signupServices.registerUser(updatedSignupModel);
      
      if (success) {
        _errorMessage = null;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Registration failed. Please try again.';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      print('Registration error: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Get current FCM token
  Future<String?> getFCMToken() async {
    try {
      String? token = _fcmService.fcmToken;
      
      if (token == null || token.isEmpty) {
        token = await _fcmService.getFCMToken();
      }
      
      return token;
    } catch (e) {
      print('Error getting FCM token in SignupProvider: $e');
      return null;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset provider state
  void reset() {
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}