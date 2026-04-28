import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/models/otp_model.dart';
import 'package:posternova/models/user_model.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/services/FCM/fcm_service.dart';
import 'package:posternova/services/auth/otp_service.dart';
import 'package:provider/provider.dart';

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
  // Future<bool> login(String mobile) async {
  //   _setLoading(true);
  //   _clearError();

  //   try {
  //     _mobileNumber = mobile;
  //     final res = await _smsService.login(LoginRequest(mobile: mobile));

  //     if (!res) {
  //       _errorMessage = _loginResponse?.body;
  //     }
  //     return true;
  //   } catch (e) {
  //     _errorMessage = e.toString();
  //     return false;
  //   } finally {
  //     _setLoading(false);
  //   }
  // }




  Future<bool> login(String mobile) async {
  _setLoading(true);
  _clearError();

  try {
    _mobileNumber = mobile;
    final res = await _smsService.login(LoginRequest(mobile: mobile));

    if (!res) {
      _errorMessage = _loginResponse?.body;
    }
    return true; // ← Always returns true regardless of res
  } catch (e) {
    _errorMessage = e.toString();
    return false;
  } finally {
    _setLoading(false);
  }
}

  /// VERIFY OTP (FCM SAFE)
  Future<void> verifyOtp(
    String otp,
    String mobile,
    BuildContext context, // ✅ ADD CONTEXT
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final String fcmToken =
          await _fcmService.getFCMTokenSafe() ?? 'default_fcm_token';

      final response = await _smsService.verifyOtp(
        VerifyOtpRequest(otp: otp, mobile: mobile, fcmToken: fcmToken),
      );

      _otpResponse = response;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Extract user
        final user = User.fromJson(data['user']);

        // ✅ Convert to LoginResponse (your app model)
        final loginResponse = LoginResponse(
          message: data['message'] ?? '',
          token: '', // API not giving token
          user: user,
          otp: '',
        );

        // ✅ Save user (IMPORTANT 🔥)
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        authProvider.setUser(loginResponse);
      } else {
        _errorMessage = response.body;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// RESEND OTP
  Future<bool> resendOtp(String mobile) async {
    _setResending(true);
    _clearError();

    try {
      final response = await _smsService.resendOtp(
        ResendOtpRequest(mobile: mobile),
      );

      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
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

  Future<void> verifyWithFirebaseToken(String idToken) async {
    _setLoading(true);
    _clearError();

    try {
      final String fcmToken =
          await _fcmService.getFCMTokenSafe() ?? 'default_fcm_token';
      final response = await _smsService.verifyFirebaseToken(idToken, fcmToken);

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
}
