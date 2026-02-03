// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:posternova/models/otp_model.dart';
// // import 'package:posternova/services/auth/otp_service.dart';

// // class SmsProvider extends ChangeNotifier {
// //   final SmsService _smsService = SmsService();
  
// //   String? _mobileNumber;

// //   bool _isLoading = false;
// //   bool _isResending = false;
// //   String? _errorMessage;
// //   http.Response? _loginResponse;
// //   http.Response? _otpResponse;
// //   http.Response? _resendOtpResponse;

// //   bool get isLoading => _isLoading;
// //   bool get isResending => _isResending;
// //   String? get errorMessage => _errorMessage;
// //   http.Response? get loginResponse => _loginResponse;
// //   http.Response? get otpResponse => _otpResponse;
// //   http.Response? get resendOtpResponse => _resendOtpResponse;

// //   // Login method
// //   Future<void> login(String mobile) async {
// //     _setLoading(true);
// //     _clearError();

// //     try {
// //       _mobileNumber = mobile; // Store mobile number for OTP verification
// //       final response = await _smsService.login(LoginRequest(mobile: mobile));
// //       _loginResponse = response;

// //       if (response.statusCode == 200) {
// //         // Success
// //       } else {
// //         _errorMessage = 'Login failed: ${response.body}';
// //       }
// //     } catch (e) {
// //       _errorMessage = e.toString();
// //     } finally {
// //       _setLoading(false);
// //     }
// //   }

// //   // Verify OTP method
// //   Future<void> verifyOtp(String otp, String mobile,String fcmToken) async {
// //     _setLoading(true);
// //     _clearError();

// //     try {
// //       final response = await _smsService.verifyOtp(VerifyOtpRequest(otp: otp, mobile: mobile,fcmToken: fcmToken));
// //       _otpResponse = response;

// //       if (response.statusCode == 200) {
// //         // Success
// //       } else {
// //         _errorMessage = 'OTP verification failed: ${response.body}';
// //       }
// //     } catch (e) {
// //       _errorMessage = e.toString();
// //     } finally {
// //       _setLoading(false);
// //     }
// //   }

// //   // Resend OTP method
// //   Future<dynamic> resendOtp(String mobile) async {
// //     _setResending(true);
// //     _clearError();

// //     try {
// //       final response = await _smsService.resendOtp(ResendOtpRequest(mobile: mobile));
// //       // _resendOtpResponse = response.;
// // return response?.otp;
// //       // if (response.statusCode == 200) {
// //       //   return response['otp'];
// //       //   // Success - OTP resent
// //       // } else {
// //       //   // _errorMessage = 'Resend OTP failed: ${response.body}';
// //       // }
// //     } catch (e) {
// //       _errorMessage = "Otp send successfully";
// //     } finally {
// //       _setResending(false);
// //     }
// //   }

// //   void _setLoading(bool value) {
// //     _isLoading = value;
// //     notifyListeners();
// //   }

// //   void _setResending(bool value) {
// //     _isResending = value;
// //     notifyListeners();
// //   }

// //   void _clearError() {
// //     _errorMessage = null;
// //   }
// // }

















// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:posternova/models/otp_model.dart';
// import 'package:posternova/services/FCM/fcm_service.dart';
// import 'package:posternova/services/auth/otp_service.dart';

// class SmsProvider extends ChangeNotifier {
//   final SmsService _smsService = SmsService();
//   final FCMService _fcmService = FCMService();
  
//   String? _mobileNumber;

//   bool _isLoading = false;
//   bool _isResending = false;
//   String? _errorMessage;
//   http.Response? _loginResponse;
//   http.Response? _otpResponse;
//   http.Response? _resendOtpResponse;

//   bool get isLoading => _isLoading;
//   bool get isResending => _isResending;
//   String? get errorMessage => _errorMessage;
//   http.Response? get loginResponse => _loginResponse;
//   http.Response? get otpResponse => _otpResponse;
//   http.Response? get resendOtpResponse => _resendOtpResponse;
//   String? get mobileNumber => _mobileNumber;

//   // Login method
//   Future<void> login(String mobile) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       _mobileNumber = mobile; // Store mobile number for OTP verification
//       final response = await _smsService.login(LoginRequest(mobile: mobile));
//       _loginResponse = response;

//       if (response.statusCode == 200) {
//         // Success
//         print('Login successful: ${response.body}');
//       } else {
//         _errorMessage = 'Login failed: ${response.body}';
//       }
//     } catch (e) {
//       _errorMessage = e.toString();
//       print('Login error: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Verify OTP method with FCM token
//   Future<void> verifyOtp(String otp, String mobile) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       // Get FCM token
//       String? fcmToken = _fcmService.fcmToken;
      
//       // If token is not available, try to get it
//       if (fcmToken == null || fcmToken.isEmpty) {
//         print('FCM token not found, fetching...');
//         fcmToken = await _fcmService.getFCMToken();
//       }

//       // Use a default token if FCM is not available (for testing/development)
//       fcmToken ??= 'default_fcm_token';

//       print('Verifying OTP with FCM Tokennnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn: $fcmToken');

//       final response = await _smsService.verifyOtp(
//         VerifyOtpRequest(
//           otp: otp,
//           mobile: mobile,
//           fcmToken: fcmToken,
//         ),
//       );
      
//       _otpResponse = response;

//       if (response.statusCode == 200) {
//         print('OTP verification successful: ${response.body}');
//       } else {
//         _errorMessage = 'OTP verification failed: ${response.body}';
//       }
//     } catch (e) {
//       _errorMessage = e.toString();
//       print('OTP verification error: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Resend OTP method
//   Future<dynamic> resendOtp(String mobile) async {
//     _setResending(true);
//     _clearError();

//     try {
//       final response = await _smsService.resendOtp(ResendOtpRequest(mobile: mobile));
      
//       if (response != null) {
//         print('OTP resent successfully');
//         return response.otp;
//       } else {
//         _errorMessage = 'Resend OTP failed';
//         return null;
//       }
//     } catch (e) {
//       _errorMessage = "OTP sent successfully";
//       print('Resend OTP error: $e');
//       return null;
//     } finally {
//       _setResending(false);
//     }
//   }

//   /// Get current FCM token
//   Future<String?> getFCMToken() async {
//     try {
//       String? token = _fcmService.fcmToken;
      
//       if (token == null || token.isEmpty) {
//         token = await _fcmService.getFCMToken();
//       }
      
//       return token;
//     } catch (e) {
//       print('Error getting FCM token: $e');
//       return null;
//     }
//   }

//   /// Clear stored mobile number
//   void clearMobileNumber() {
//     _mobileNumber = null;
//     notifyListeners();
//   }

//   /// Reset all state
//   void reset() {
//     _isLoading = false;
//     _isResending = false;
//     _errorMessage = null;
//     _loginResponse = null;
//     _otpResponse = null;
//     _resendOtpResponse = null;
//     _mobileNumber = null;
//     notifyListeners();
//   }

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   void _setResending(bool value) {
//     _isResending = value;
//     notifyListeners();
//   }

//   void _clearError() {
//     _errorMessage = null;
//   }
// }












import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/models/otp_model.dart';
import 'package:posternova/services/FCM/fcm_service.dart';
import 'package:posternova/services/auth/otp_service.dart';

class SmsProvider extends ChangeNotifier {
  final SmsService _smsService = SmsService();
  final FCMService _fcmService = FCMService();

  String? _mobileNumber;

  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;
  http.Response? _loginResponse;
  http.Response? _otpResponse;
  http.Response? _resendOtpResponse;

  bool get isLoading => _isLoading;
  bool get isResending => _isResending;
  String? get errorMessage => _errorMessage;
  http.Response? get loginResponse => _loginResponse;
  http.Response? get otpResponse => _otpResponse;
  http.Response? get resendOtpResponse => _resendOtpResponse;
  String? get mobileNumber => _mobileNumber;

  /// LOGIN
  Future<void> login(String mobile) async {
    _setLoading(true);
    _clearError();

    try {
      _mobileNumber = mobile;
      _loginResponse =
          await _smsService.login(LoginRequest(mobile: mobile));

      if (_loginResponse?.statusCode != 200) {
        _errorMessage = _loginResponse?.body;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// VERIFY OTP (FCM SAFE)
  Future<void> verifyOtp(String otp, String mobile) async {
    _setLoading(true);
    _clearError();

    try {
      final String fcmToken =
          await _fcmService.getFCMTokenSafe() ?? 'default_fcm_token';

      final response = await _smsService.verifyOtp(
        VerifyOtpRequest(
          otp: otp,
          mobile: mobile,
          fcmToken: fcmToken,
        ),
      );

      _otpResponse = response;

      if (response.statusCode != 200) {
        _errorMessage = response.body;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// RESEND OTP
  Future<dynamic> resendOtp(String mobile) async {
    _setResending(true);
    _clearError();

    try {
      final response =
          await _smsService.resendOtp(ResendOtpRequest(mobile: mobile));

      if (response != null) return response.otp;
      _errorMessage = 'Failed to resend OTP';
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _setResending(false);
    }
  }

  void reset() {
    _isLoading = false;
    _isResending = false;
    _errorMessage = null;
    _loginResponse = null;
    _otpResponse = null;
    _resendOtpResponse = null;
    _mobileNumber = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setResending(bool value) {
    _isResending = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
