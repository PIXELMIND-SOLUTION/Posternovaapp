import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/models/otp_model.dart';
import 'package:posternova/services/auth/otp_service.dart';

class SmsProvider extends ChangeNotifier {
  final SmsService _smsService = SmsService();
  
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

  // Login method
  Future<void> login(String mobile) async {
    _setLoading(true);
    _clearError();

    try {
      _mobileNumber = mobile; // Store mobile number for OTP verification
      final response = await _smsService.login(LoginRequest(mobile: mobile));
      _loginResponse = response;

      if (response.statusCode == 200) {
        // Success
      } else {
        _errorMessage = 'Login failed: ${response.body}';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP method
  Future<void> verifyOtp(String otp) async {
    _setLoading(true);
    _clearError();

    try {
      if (_mobileNumber == null) {
        _errorMessage = 'Mobile number not found. Please login again.';
        return;
      }
      final response = await _smsService.verifyOtp(VerifyOtpRequest(otp: otp, mobile: _mobileNumber!));
      _otpResponse = response;

      if (response.statusCode == 200) {
        // Success
      } else {
        _errorMessage = 'OTP verification failed: ${response.body}';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Resend OTP method
  Future<void> resendOtp(String mobile) async {
    _setResending(true);
    _clearError();

    try {
      final response = await _smsService.resendOtp(ResendOtpRequest(mobile: mobile));
      _resendOtpResponse = response;

      if (response.statusCode == 200) {
        // Success - OTP resent
      } else {
        // _errorMessage = 'Resend OTP failed: ${response.body}';
      }
    } catch (e) {
      _errorMessage = "Otp send successfully";
    } finally {
      _setResending(false);
    }
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