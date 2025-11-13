
import 'package:flutter/material.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/user_model.dart';
import 'package:posternova/services/auth/login_service.dart';

class AuthProvider extends ChangeNotifier {
  final Authservice _authservice = Authservice();
  bool _isLoading=false;
  String?_error;
  LoginResponse? _user;
  
  LoginResponse? get user => _user;
  bool get isLoading=>_isLoading;
  String? get error=>_error;
  // Initialize method to load saved user on app start
  Future<void> initialize() async {
    _user = await AuthPreferences.getUserData();
    notifyListeners();
  }


  Future<bool> uploadProfileImage(String userId, String imagePath) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    print("lllllllllllllllllllllllllllll$userId");
    print("lllllllllllllllllllllllllllll$imagePath");
    final imageUrl = await _authservice.uploadProfileImage(userId, imagePath);

    print("fdfkdlfdfffkjddfdf;fjjfjklfj$imageUrl");
    if (imageUrl != null) {
      // Update the profile image in the user model within LoginResponse
      if (_user != null) {
        _user = _user!.copyWith(
          user: _user!.user.copyWith(profileImage: imageUrl)
        );
        // Save the updated user data to SharedPreferences
        await AuthPreferences.saveUserData(_user!);
      }
      _error = null;
      notifyListeners();
      return true;
    } else {
      _error = 'Failed to upload profile image';
      notifyListeners();
      return false;
    }
  } catch (e) {
    _error = 'Error uploading image: $e';
    notifyListeners();
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<bool> login(String mobile) async {
    try {
      final userData = await _authservice.login(mobile);
      if (userData != null) {
        _user = userData;
        // Save to SharedPreferences
        await AuthPreferences.saveUserData(userData);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void setUser(LoginResponse user) async {
    _user = user;
    // Save to SharedPreferences
    await AuthPreferences.saveUserData(user);
    notifyListeners();
  }
  
  // Method to handle logout
  Future<bool> logout() async {
    try {
      final result = await AuthPreferences.clearUserData();
      if (result) {
        _user = null;
        notifyListeners();
      }
      return result;
    } catch (e) {
      return false;
    }
  }
  
  // Method to check if user is logged in
  Future<bool> isLoggedIn() async {
    return await AuthPreferences.isLoggedIn();
  }
}