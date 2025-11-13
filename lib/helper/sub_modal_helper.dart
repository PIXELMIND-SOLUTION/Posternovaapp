import 'package:shared_preferences/shared_preferences.dart';

class ModalPreferences {
  static const String _subscriptionModalKey = 'subscription_modal_shown';
  static const String _subscriptionModalDateKey = 'subscription_modal_date';
  static const String _referEarnModalKey = 'refer_earn_modal_shown';
  
  // Track if subscription modal has been shown
  static Future<bool> hasShownSubscriptionModal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_subscriptionModalKey) ?? false;
  }
  
  // Mark subscription modal as shown
  static Future<void> setSubscriptionModalShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionModalKey, true);
    await prefs.setString(_subscriptionModalDateKey, DateTime.now().toIso8601String());
  }
  
  // Check if we should show subscription modal again after certain days
  static Future<bool> shouldShowSubscriptionModalAgain({int daysBetween = 7}) async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_subscriptionModalDateKey);
    
    if (dateString == null) return true;
    
    final lastShownDate = DateTime.parse(dateString);
    final daysSinceShown = DateTime.now().difference(lastShownDate).inDays;
    
    return daysSinceShown >= daysBetween;
  }
  
  // Track if refer and earn modal has been shown
  static Future<bool> hasShownReferEarnModal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_referEarnModalKey) ?? false;
  }
  
  // Mark refer and earn modal as shown
  static Future<void> setReferEarnModalShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_referEarnModalKey, true);
  }
  
  // Reset modal preferences (call this when user logs out)
  static Future<void> clearModalPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_subscriptionModalKey);
    await prefs.remove(_subscriptionModalDateKey);
    await prefs.remove(_referEarnModalKey);
  }
  
  // Reset only subscription modal (call this when user purchases a plan)
  static Future<void> resetSubscriptionModal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_subscriptionModalKey);
    await prefs.remove(_subscriptionModalDateKey);
  }
}