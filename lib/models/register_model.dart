class SignupModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String dob;
  final String marriageAnniversary;
  final String? referralCode;

  SignupModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.marriageAnniversary,
    this.referralCode,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      dob: json['dob'] ?? '',
      marriageAnniversary: json['marriageAnniversary'] ?? '',
      referralCode: json['referralCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'dob': dob,
      'marriageAnniversary': marriageAnniversary,
      'referralCode': referralCode,
    };
  }
}