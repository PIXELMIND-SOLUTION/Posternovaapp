import 'package:shared_preferences/shared_preferences.dart';

class UsageStorageService {
  static const _timeKey = "total_seconds";
  static const _dateKey = "last_date";
  static const _apiKey = "api_called";

  Future<void> saveUsage(int seconds, String date, bool apiCalled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_timeKey, seconds);
    await prefs.setString(_dateKey, date);
    await prefs.setBool(_apiKey, apiCalled);
  }

  Future<Map<String, dynamic>> getUsage() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "seconds": prefs.getInt(_timeKey) ?? 0,
      "date": prefs.getString(_dateKey) ?? "",
      "apiCalled": prefs.getBool(_apiKey) ?? false,
    };
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_timeKey);
    await prefs.remove(_dateKey);
    await prefs.remove(_apiKey);
  }
}
