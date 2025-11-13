class VerifyOtpRequest {
  final String otp;
  final String mobile;

  VerifyOtpRequest({required this.otp, required this.mobile});

  Map<String, dynamic> tojson() {
    return {'otp': otp, 'mobile': mobile};
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

