class PhonePePaymentResponse {
  final bool success;
  final String? message;
  final String? merchantOrderId;
  final ResponseData? response;
  final int? amount;
  final String? currency;
  final PlanData? plan;
  final UserData? user;
  
  PhonePePaymentResponse({
    required this.success,
    this.message,
    this.merchantOrderId,
    this.response,
    this.amount,
    this.currency,
    this.plan,
    this.user,
  });
  
  // Convenience getter for redirectUrl
  String? get redirectUrl => response?.redirectUrl;
  
  factory PhonePePaymentResponse.fromJson(Map<String, dynamic> json) {
    return PhonePePaymentResponse(
      success: json['success'] ?? false,
      message: json['message'],
      merchantOrderId: json['merchantOrderId'],
      response: json['response'] != null 
          ? ResponseData.fromJson(json['response']) 
          : null,
      amount: json['amount'],
      currency: json['currency'],
      plan: json['plan'] != null 
          ? PlanData.fromJson(json['plan']) 
          : null,
      user: json['user'] != null 
          ? UserData.fromJson(json['user']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'merchantOrderId': merchantOrderId,
      'response': response?.toJson(),
      'amount': amount,
      'currency': currency,
      'plan': plan?.toJson(),
      'user': user?.toJson(),
    };
  }
}

class ResponseData {
  final String? orderId;
  final String? state;
  final int? expireAt;
  final String? redirectUrl;
  
  ResponseData({
    this.orderId,
    this.state,
    this.expireAt,
    this.redirectUrl,
  });
  
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      orderId: json['orderId'],
      state: json['state'],
      expireAt: json['expireAt'],
      redirectUrl: json['redirectUrl'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'state': state,
      'expireAt': expireAt,
      'redirectUrl': redirectUrl,
    };
  }
}

class PlanData {
  final String? id;
  final String? name;
  final int? offerPrice;
  
  PlanData({
    this.id,
    this.name,
    this.offerPrice,
  });
  
  factory PlanData.fromJson(Map<String, dynamic> json) {
    return PlanData(
      id: json['id'],
      name: json['name'],
      offerPrice: json['offerPrice'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'offerPrice': offerPrice,
    };
  }
}

class UserData {
  final String? id;
  final String? name;
  final String? email;
  
  UserData({
    this.id,
    this.name,
    this.email,
  });
  
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}