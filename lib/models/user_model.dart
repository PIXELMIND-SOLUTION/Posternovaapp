
class LoginResponse {
  final String message;
  final String token;
  final User user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? 'No message', // Handle null message
      token: json['token'] ?? '', // Handle null token
      user: User.fromJson(json['user'] ?? {}), // Handle null user object
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'user': user.toJson(),
    };
  }

  // Add copyWith method
  LoginResponse copyWith({
    String? message,
    String? token,
    User? user,
  }) {
    return LoginResponse(
      message: message ?? this.message,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}

class User {
  final String id;
  final String mobile;
  final String name;
  final String email;
  final String profileImage;
  final bool isSubscribedPlan;

  User({
    required this.id,
    required this.mobile,
    required this.name,
    this.email = '',
    this.profileImage = '',
    this.isSubscribedPlan = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ??
          json['id'] ??
          '', // Handle both _id and id, with fallback
      mobile: json['mobile'] ?? '', // Handle null mobile
      name: json['name'] ?? '', // Handle null name
      email: json['email'] ?? '', // Handle null email
      profileImage: json['profileImage'] ?? '',
      isSubscribedPlan: json['isSubscribedPlan'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mobile': mobile,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'isSubscribedPlan': isSubscribedPlan,
    };
  }

  User copyWith({
  String? id,
  String? mobile,
  String? name,
  String? email,
  String? profileImage,
  bool? isSubscribedPlan,
}) {
  return User(
    id: id ?? this.id,
    mobile: mobile ?? this.mobile,
    name: name ?? this.name,
    email: email ?? this.email,
    profileImage: profileImage ?? this.profileImage,
    isSubscribedPlan: isSubscribedPlan ?? this.isSubscribedPlan,
  );
}
}
