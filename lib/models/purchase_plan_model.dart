
class PlanPurchaseRequestModel {
  final String userId;
  final String planId;
  final String transactionId;

  PlanPurchaseRequestModel({
    required this.userId,
    required this.planId,
    required this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'planId': planId,
      'transactionId': transactionId,
    };
  }
}


// File: lib/models/plan_purchase_response_model.dart
class PlanPurchaseResponseModel {
  final String message;
  final PurchasedPlanDetails plan;
  final String upiId;
  final String qrCode;

  PlanPurchaseResponseModel({
    required this.message,
    required this.plan,
    required this.upiId,
    required this.qrCode,
  });

  factory PlanPurchaseResponseModel.fromJson(Map<String, dynamic> json) {
    return PlanPurchaseResponseModel(
      message: json['message'],
      plan: PurchasedPlanDetails.fromJson(json['plan']),
      upiId: json['upiId'],
      qrCode: json['qrCode'],
    );
  }
}

class PurchasedPlanDetails {
  final String planId;
  final String name;
  final int originalPrice;
  final int offerPrice;
  final int discountPercentage;
  final String duration;
  final DateTime startDate;
  final DateTime endDate;

  PurchasedPlanDetails({
    required this.planId,
    required this.name,
    required this.originalPrice,
    required this.offerPrice,
    required this.discountPercentage,
    required this.duration,
    required this.startDate,
    required this.endDate,
  });

  factory PurchasedPlanDetails.fromJson(Map<String, dynamic> json) {
    return PurchasedPlanDetails(
      planId: json['planId'],
      name: json['name'],
      originalPrice: json['originalPrice'],
      offerPrice: json['offerPrice'],
      discountPercentage: json['discountPercentage'],
      duration: json['duration'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}