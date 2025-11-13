import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/network_helper.dart';
import 'package:posternova/models/otp_model.dart';

class SmsService {
  /// Login request with mobile number
  Future<http.Response> login(LoginRequest request) async {
    final url = Uri.parse(ApiConstants.login);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      return response;
    } on SocketException {
      throw 'Please turn on your internet connection';
    } catch (e) {
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      throw Exception('Login failed: $e');
    }
  }

  /// Verify OTP request
  Future<http.Response> verifyOtp(VerifyOtpRequest request) async {
    final url = Uri.parse(ApiConstants.verifyOtp);

    try {

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.tojson()),
      );

    print('Response status code for OTP: ${response.statusCode}');
    print('Response body: ${response.body}');

      return response;
    } on SocketException {
      throw 'Please turn on your internet connection';
    } catch (e) {
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      throw Exception('OTP verification failed: $e');
    }
  }

  /// Resend OTP request
  Future<http.Response> resendOtp(ResendOtpRequest request) async {
    final url = Uri.parse(ApiConstants.resendOtp);
      
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      return response;
    } on SocketException {
      throw 'Please turn on your internet connection';
    } catch (e) {
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      throw Exception('Resend OTP failed: $e');
    }
  }
}

// Add this ResendOtpRequest class to your existing otp_model.dart file

class ResendOtpRequest {
  final String mobile;

  ResendOtpRequest({required this.mobile});

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
    };
  }
}
