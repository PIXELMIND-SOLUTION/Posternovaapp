import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GreetService {
  Future<GreetResponse> getGreet(String userId) async {
    final url = Uri.parse('http://31.97.228.17:4061/api/users/getgreet/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Greet API Response status code: ${response.statusCode}');
      print('Greet API Response body: ${response.body}');
      print('User ID for greetings: $userId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GreetResponse.fromJson(data);
      } else {
        throw Exception('Failed to get greet data: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Please turn on your internet connection');
    } catch (e) {
      throw Exception('Get greet failed: $e');
    }
  }
}

/// Greet Response Model
class GreetResponse {
  final bool success;
  final String? message;
  final GreetData? data;

  GreetResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory GreetResponse.fromJson(Map<String, dynamic> json) {
    return GreetResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? GreetData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

/// Greet Data Model
class GreetData {
  final String? title;
  final String? body;
  final String? type;

  GreetData({
    this.title,
    this.body,
    this.type,
  });

  factory GreetData.fromJson(Map<String, dynamic> json) {
    return GreetData(
      title: json['title'],
      body: json['body'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'type': type,
    };
  }
}