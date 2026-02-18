import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/network_helper.dart';
import 'package:posternova/models/user_model.dart';

class Authservice {
  
  Future<LoginResponse?> login(String mobile) async {
    try {
      print('Mobile number: $mobile');
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobile}),
      );

      print('${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Successsssss$data');
        return LoginResponse.fromJson(data);
      } else {
        throw Exception('Login Failed');
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw 'Please turn on your internet connection';
    } catch (e) {
      print('Errrrrrrrrrr $e');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      throw 'Login failed: ${e.toString()}';
    }
  }

  Future<String?> uploadProfileImage(String userId, String imagePath) async {
    try {
      print("lllllllllllllllllllllllllllll$userId");
      print("lllllllllllllllllllllllllllll$imagePath");

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiConstants.uploadProfileImage(userId)),
      );

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath('profileImage', imagePath));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("kkkkkkkk${response.statusCode}");
      print('gggggggggggggggggggggggg${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Based on your API response, the profile image URL should be in data['profileImage']
        print("pppppppppppppp${data['user']['profileImage']}");
        return data['user']['profileImage'];
      } else {
        print('Error uploading image: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw 'Please turn on your internet connection';
    } catch (e) {
      print('Error uploading profile image: $e');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      return null;
    }
  }


//   Future<Map<String, dynamic>?> updateProfile({
//   required String userId,
//   required String name,
//   required String email,
//   required String mobile,
//   String? dob,
//   String? marriageAnniversaryDate,
// }) async {
//   try {
//     print('Updating profile for user: $userId');
    
//     final response = await http.put(
//       Uri.parse(ApiConstants.updateProfile(userId)),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'email': email,
//         'mobile': mobile,
//         'dob': dob ?? '',
//         'marriageAnniversaryDate': marriageAnniversaryDate ?? '',
//       }),
//     );

//     print('Update profile status code: ${response.statusCode}');
//     print('Update profile response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       print('Profile updated successfully: $data');
//       return data;
//     } else {
//       final errorData = jsonDecode(response.body);
//       throw Exception(errorData['message'] ?? 'Failed to update profile');
//     }
//   } on SocketException catch (e) {
//     print('No internet connection: $e');
//     throw 'Please turn on your internet connection';
//   } catch (e) {
//     print('Error updating profile: $e');
//     if (NetworkHelper.isNoInternetError(e)) {
//       throw 'Please turn on your internet connection';
//     }
//     throw 'Failed to update profile: ${e.toString()}';
//   }
// }
}