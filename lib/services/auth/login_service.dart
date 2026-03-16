// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:posternova/constants/api_constant.dart';
// import 'package:posternova/helper/network_helper.dart';
// import 'package:posternova/models/user_model.dart';

// class Authservice {
  
//   Future<LoginResponse?> login(String mobile) async {
//     try {
//       print('Mobile number: $mobile');
//       final response = await http.post(
//         Uri.parse(ApiConstants.login),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'mobile': mobile}),
//       );

//       print('${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('Successsssss$data');
//         return LoginResponse.fromJson(data);
//       } else {
//         throw Exception('Login Failed');
//       }
//     } on SocketException catch (e) {
//       print('No internet connection: $e');
//       throw 'Please turn on your internet connection';
//     } catch (e) {
//       print('Errrrrrrrrrr $e');
//       if (NetworkHelper.isNoInternetError(e)) {
//         throw 'Please turn on your internet connection';
//       }
//       throw 'Login failed: ${e.toString()}';
//     }
//   }

//   Future<String?> uploadProfileImage(String userId, String imagePath) async {
//     try {
//       print("lllllllllllllllllllllllllllll$userId");
//       print("lllllllllllllllllllllllllllll$imagePath");

//       var request = http.MultipartRequest(
//         'PUT',
//         Uri.parse(ApiConstants.uploadProfileImage(userId)),
//       );

//       // Add the image file
//       request.files.add(await http.MultipartFile.fromPath('profileImage', imagePath));

//       // Send the request
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       print("kkkkkkkk${response.statusCode}");
//       print('gggggggggggggggggggggggg${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         // Based on your API response, the profile image URL should be in data['profileImage']
//         print("pppppppppppppp${data['user']['profileImage']}");
//         return data['user']['profileImage'];
//       } else {
//         print('Error uploading image: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return null;
//       }
//     } on SocketException catch (e) {
//       print('No internet connection: $e');
//       throw 'Please turn on your internet connection';
//     } catch (e) {
//       print('Error uploading profile image: $e');
//       if (NetworkHelper.isNoInternetError(e)) {
//         throw 'Please turn on your internet connection';
//       }
//       return null;
//     }
//   }

// }


















// lib/services/auth/auth_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:posternova/constants/api_constant.dart';
import 'package:posternova/helper/network_helper.dart';
import 'package:posternova/models/user_model.dart';

class AuthService {
  
  // Existing login method
  Future<LoginResponse?> login(String mobile) async {
    try {
      print('Mobile number: $mobile');
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': mobile}),
      );

      print('Login Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Login Success: $data');
        return LoginResponse.fromJson(data);
      } else {
        throw Exception('Login Failed');
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw 'Please turn on your internet connection';
    } catch (e) {
      print('Login Error: $e');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      throw 'Login failed: ${e.toString()}';
    }
  }

  // New Google Sign-In method
  Future<LoginResponse?> googleSignIn(Map<String, dynamic> googleData) async {
    try {
      print('Sending Google Sign-In data to backend');
      print('Google Data: $googleData');

      // final response = await http.post(
      //   Uri.parse(ApiConstants.googleSignIn),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(googleData),
      // );

      // print('Google Sign-In Response Status: ${response.statusCode}');
      // print('Google Sign-In Response Body: ${response.body}');

      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   print('Google Sign-In Success: $data');
      //   return LoginResponse.fromJson(data);
      // } else if (response.statusCode == 201) {
      //   // New user created
      //   final data = jsonDecode(response.body);
      //   print('New Google user created: $data');
      //   return LoginResponse.fromJson(data);
      // } else {
      //   print('Google Sign-In failed with status: ${response.statusCode}');
      //   print('Response body: ${response.body}');
      //   return null;
      // }
    } on SocketException catch (e) {
      print('No internet connection during Google Sign-In: $e');
      throw 'Please turn on your internet connection';
    } catch (e) {
      print('Google Sign-In API Error: $e');
      if (NetworkHelper.isNoInternetError(e)) {
        throw 'Please turn on your internet connection';
      }
      throw 'Google Sign-In failed: ${e.toString()}';
    }
  }


  // Existing uploadProfileImage method
  Future<String?> uploadProfileImage(String userId, String imagePath) async {
    try {
      print("Uploading profile image for user: $userId");
      print("Image path: $imagePath");

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiConstants.uploadProfileImage(userId)),
      );

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath('profileImage', imagePath));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Upload Response Status: ${response.statusCode}");
      print('Upload Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Based on your API response, the profile image URL should be in data['user']['profileImage']
        print("Profile Image URL: ${data['user']['profileImage']}");
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

}