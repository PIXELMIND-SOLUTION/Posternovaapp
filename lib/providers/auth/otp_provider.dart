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
      _loginResponse = await _smsService.login(LoginRequest(mobile: mobile));

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
        VerifyOtpRequest(otp: otp, mobile: mobile, fcmToken: fcmToken),
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
      final response = await _smsService.resendOtp(
        ResendOtpRequest(mobile: mobile),
      );

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
