
import 'package:posternova/models/subscribe_plan_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String profileImage;
  final DateTime? dob;
  final DateTime? marriageAnniversaryDate;
  final List<SubscribePlanModel> subscribedPlans;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.profileImage,
    this.dob,
    this.marriageAnniversaryDate,
    required this.subscribedPlans,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      profileImage: json['profileImage'] ?? '',
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      marriageAnniversaryDate: json['marriageAnniversaryDate'] != null
          ? DateTime.tryParse(json['marriageAnniversaryDate'])
          : null,
      subscribedPlans: (json['subscribedPlans'] as List)
          .map((e) => SubscribePlanModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'profileImage': profileImage,
      'dob': dob?.toIso8601String(),
      'marriageAnniversaryDate': marriageAnniversaryDate?.toIso8601String(),
      'subscribedPlans': subscribedPlans.map((e) => e.toJson()).toList(),
    };
  }
}
