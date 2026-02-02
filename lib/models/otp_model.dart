class VerifyOtpRequest {
  final String otp;
  final String mobile;
  final String fcmToken;

  VerifyOtpRequest({required this.otp, required this.mobile,required this.fcmToken});

  Map<String, dynamic> tojson() {
    return {'otp': otp, 'mobile': mobile,'fcmToken':fcmToken};
  }
}



class LoginRequest {
  final String mobile;

  LoginRequest({required this.mobile});

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
    };
  }
}

