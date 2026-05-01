import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/network_helper.dart';
import 'package:posternova/models/otp_model.dart';
import 'package:posternova/models/user_model.dart';

class SmsService {
  /// Login request with mobile number
  Future<bool> login(LoginRequest request) async {
    final url = Uri.parse(ApiConstants.login);

    try {
      print("kkkkkkkkkkkkkkkkkkkkkkkkk$url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      print("kkkkkkkkkkkkkkkkkkkkkkkkk${response.statusCode}");
      return true;
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
      print(
        "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk",
      );
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

  Future<http.Response> verifyFirebaseToken(
    String firebaseToken,
    String fcmToken,
  ) async {
    final url = Uri.parse(
      "http://31.97.228.17:4061/api/users/verify-firebase-otp",
    );

    // ✅ Payload
    final payload = {"idToken": firebaseToken, "fcmToken": fcmToken};

    // ✅ Print payload
    print("📤 VERIFY FIREBASE OTP PAYLOAD:");
    print(url);

    print(jsonEncode(payload));

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    // ✅ Print response
    print("📥 VERIFY FIREBASE OTP RESPONSE:");
    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");

    return response;
  }

  /// Resend OTP request
  Future<bool> resendOtp(ResendOtpRequest request) async {
    final url = Uri.parse(ApiConstants.resendOtp);

    // try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }

    // } on SocketException {
    //   throw 'Please turn on your internet connection';
    // } catch (e) {
    //   if (NetworkHelper.isNoInternetError(e)) {
    //     throw 'Please turn on your internet connection';
    //   }
    //   throw Exception('Resend OTP failed: $e');
    // }
  }
}

// Add this ResendOtpRequest class to your existing otp_model.dart file

class ResendOtpRequest {
  final String mobile;

  ResendOtpRequest({required this.mobile});

  Map<String, dynamic> toJson() {
    return {'mobile': mobile};
  }
}
