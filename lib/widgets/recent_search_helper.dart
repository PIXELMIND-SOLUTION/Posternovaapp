import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchHelper {
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 10;

  static Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList(_recentSearchesKey) ?? [];
    return searches;
  }

  static Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = await getRecentSearches();
    
    // Remove if already exists (to move to top)
    searches.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    
    // Add to beginning
    searches.insert(0, query.trim());
    
    // Keep only max items
    if (searches.length > _maxRecentSearches) {
      searches = searches.sublist(0, _maxRecentSearches);
    }
    
    await prefs.setStringList(_recentSearchesKey, searches);
  }

  static Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
  }

  static Future<void> removeRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = await getRecentSearches();
    searches.removeWhere((item) => item == query);
    await prefs.setStringList(_recentSearchesKey, searches);
  }
}