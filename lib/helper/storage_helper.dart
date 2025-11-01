import 'dart:convert';
import 'package:posternova/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  // Key constants
  static const String userKey = 'user_data';
  static const String tokenKey = 'auth_token';
  static const String isLoggedInKey = 'is_logged_in';
  static const String isVerifiedKey = 'is_verified';
  static const String userEmailKey = 'user_email';
  static const String isPurchasedPlanKey = 'is_purchased_plan'; // New key for user email

  // Save user data to SharedPreferences
  static Future<bool> saveUserData(LoginResponse userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save the complete user object as JSON string
      await prefs.setString(userKey, jsonEncode(userData.toJson()));
      
      // Save token separately for easy access
      await prefs.setString(tokenKey, userData.token);
      
      // Set logged in status
      await prefs.setBool(isLoggedInKey, true);
      
      // Save user email separately if available
      if (userData.user.email != null) {
        await prefs.setString(userEmailKey, userData.user!.email!);
      }

          await _savePurchasedPlanStatus(userData.user);

      print('hhhhhhhhhhhhhhhhhhhhhhhhh${getUserData()}');
      
      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }


   static Future<void> _savePurchasedPlanStatus(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save the subscription status directly from the user object
      await prefs.setBool(isPurchasedPlanKey, user.isSubscribedPlan);
    } catch (e) {
      print('Error saving purchased plan status: $e');
    }
  }

  // Get saved user data
  static Future<LoginResponse?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final userDataString = prefs.getString(userKey);
      if (userDataString == null) return null;
      
      final Map<String, dynamic> userDataMap = jsonDecode(userDataString);
      return LoginResponse.fromJson(userDataMap);
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }

  // Get user email directly
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }
  
   static Future<bool> hasPurchasedPlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isPurchasedPlanKey) ?? false;
  }



static Future<bool> updatePurchasedPlanStatus(bool hasPurchasedPlan) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(isPurchasedPlanKey, hasPurchasedPlan);
      return true;
    } catch (e) {
      print('Error updating purchased plan status: $e');
      return false;
    }
  }

   static Future<bool> getPurchasedPlanStatus() async {
    try {
      final userData = await getUserData();
      return userData?.user.isSubscribedPlan ?? false;
    } catch (e) {
      print('Error getting purchased plan status: $e');
      return false;
    }
  }

   static Future<bool> hasActiveSubscription() async {
    try {
      return await getPurchasedPlanStatus();
    } catch (e) {
      print('Error checking active subscription: $e');
      return false;
    }
  }
  // Set user as verified (call this after OTP verification)
  static Future<bool> setUserVerified() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(isVerifiedKey, true);
      return true;
    } catch (e) {
      print('Error setting user verified: $e');
      return false;
    }
  }
  
  // Check if user is verified
  static Future<bool> isUserVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isVerifiedKey) ?? false;
  }

  // Clear user data (for logout)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(userKey);
      await prefs.remove(tokenKey);
      await prefs.remove(userEmailKey);
       await prefs.remove(isPurchasedPlanKey);   // Also clear email
      await prefs.setBool(isLoggedInKey, false);
      await prefs.setBool(isVerifiedKey, false);
      return true;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }
}