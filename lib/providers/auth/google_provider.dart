// lib/providers/auth/google_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:posternova/models/user_model.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/services/FCM/fcm_service.dart';
import 'package:posternova/services/auth/google_auth_service.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GoogleProvider extends ChangeNotifier {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
    final FCMService _fcmService = FCMService();

  
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _googleUserData;
  http.Response? _googleSignInResponse;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get googleUserData => _googleUserData;
  http.Response? get googleSignInResponse => _googleSignInResponse;

  // Sign in with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get Google user data
      final googleData = await _googleAuthService.signInWithGoogle();
      
      if (googleData == null) {
        // User canceled sign-in
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _googleUserData = googleData;
      notifyListeners();

             final String fcmToken =
          await _fcmService.getFCMTokenSafe() ?? 'default_fcm_token';

      // Send data to backend
      final response = await _googleAuthService.sendGoogleDataToBackend(googleData,fcmToken);
      _googleSignInResponse = response;

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Parse the response
        final loginResponse = LoginResponse.fromJson(data);
        
        // Save user data to SharedPreferences
        await AuthPreferences.saveUserData(loginResponse);
        
        // Update AuthProvider
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setUser(loginResponse);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Google Sign-In failed: ${response?.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleAuthService.signOut();
    _googleUserData = null;
    _googleSignInResponse = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}