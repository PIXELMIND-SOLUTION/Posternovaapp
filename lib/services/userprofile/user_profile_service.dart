import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/models/get_profile_model.dart';

class UserProfileServices {
  Future<UserModel> fetchUserProfile(String userId) async {
    final url = Uri.parse('${ApiConstants.getUserProfile}/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load user profile:${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user profile:$e');
    }
  }
}