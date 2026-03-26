class AdminAmount {
  final String id;
  final String name;
  final int amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminAmount({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminAmount.fromJson(Map<String, dynamic> json) {
    return AdminAmount(
      id: json['_id'] as String,
      name: json['name'] as String,
      amount: json['amount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AdminAmountResponse {
  final bool success;
  final List<AdminAmount> data;

  AdminAmountResponse({required this.success, required this.data});

  factory AdminAmountResponse.fromJson(Map<String, dynamic> json) {
    return AdminAmountResponse(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((item) => AdminAmount.fromJson(item))
          .toList(),
    );
  }
}
