import 'package:posternova/models/payment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhonePePreferenceManager {
  // Keys for SharedPreferences
  static const String _keyMerchantOrderId = 'phonepe_merchant_order_id';
  static const String _keyOrderId = 'phonepe_order_id';
  static const String _keyPlanId = 'phonepe_plan_id';

  // Save PhonePe payment response data to SharedPreferences
  static Future<bool> savePhonePePaymentData(PhonePePaymentResponse response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    bool success = true;
    
    // Save merchantOrderId if available
    if (response.merchantOrderId != null) {
      success = success && await prefs.setString(_keyMerchantOrderId, response.merchantOrderId!);
    }
    
    // Save orderId if available
    if (response.response?.orderId != null) {
      success = success && await prefs.setString(_keyOrderId, response.response!.orderId!);
    }
    
    // Save planId if available
    if (response.plan?.id != null) {
      success = success && await prefs.setString(_keyPlanId, response.plan!.id!);
    }
    
    return success;
  }
  
  // Get merchantOrderId from SharedPreferences
  static Future<String?> getMerchantOrderId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMerchantOrderId);
  }
  
  // Get orderId from SharedPreferences
  static Future<String?> getOrderId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOrderId);
  }
  
  // Get planId from SharedPreferences
  static Future<String?> getPlanId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPlanId);
  }
  
  // Get all PhonePe payment data as a Map
  static Future<Map<String, String?>> getAllPhonePeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    return {
      'merchantOrderId': prefs.getString(_keyMerchantOrderId),
      'orderId': prefs.getString(_keyOrderId),
      'planId': prefs.getString(_keyPlanId),
    };
  }
  
  // Clear all PhonePe payment data
  static Future<bool> clearPhonePeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    bool success = true;
    success = success && await prefs.remove(_keyMerchantOrderId);
    success = success && await prefs.remove(_keyOrderId);
    success = success && await prefs.remove(_keyPlanId);
    
    return success;
  }
}