class SignupModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
   String? dob;
   String? marriageAnniversary;
  final String? referralCode;
  final String?fcmtoken;

  SignupModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
     this.dob,
     this.marriageAnniversary,
    this.referralCode,
    this.fcmtoken,
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
      fcmtoken: json['fcmToken'],
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
      'fcmToken':fcmtoken,
    };
  }
}