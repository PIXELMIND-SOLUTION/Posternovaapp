// hot_topic_reels_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/models/hot_topic_model.dart';

class HotTopicReelsService {
  static const String _baseUrl = 'http://31.97.206.144:4061/api/users';

  Future<HotTopicReelsModel> fetchHotTopicReels(String userId) async {
    final url = Uri.parse('$_baseUrl/allhottopicreels/$userId');
    print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu$url");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return HotTopicReelsModel.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to fetch hot topic reels. Status: ${response.statusCode}',
      );
    }
  }
}
