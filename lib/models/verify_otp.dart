import 'package:posternova/models/user_model.dart';

class VerifyOtpResponse {
  final String message;
  final User user;
  final bool isVerified;

  VerifyOtpResponse({
    required this.message,
    required this.user,
    required this.isVerified,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      isVerified: json['isVerified'] ?? false,
    );
  }
}
