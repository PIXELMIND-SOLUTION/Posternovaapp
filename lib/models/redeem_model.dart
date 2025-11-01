// import 'dart:ui';

// import 'package:flutter/material.dart';

// class RedeemResponse {
//   final String message;
//   final RedemptionData redemption;

//   RedeemResponse({
//     required this.message,
//     required this.redemption,
//   });

//   factory RedeemResponse.fromJson(Map<String, dynamic> json) {
//     return RedeemResponse(
//       message: json['message'] ?? '',
//       redemption: RedemptionData.fromJson(json['redemption']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'redemption': redemption.toJson(),
//     };
//   }
// }

// class RedemptionData {
//   final String id;
//   final String user;
//   final double amount;
//   final String accountHolderName;
//   final String accountNumber;
//   final String ifscCode;
//   final String bankName;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int version;

//   RedemptionData({
//     required this.id,
//     required this.user,
//     required this.amount,
//     required this.accountHolderName,
//     required this.accountNumber,
//     required this.ifscCode,
//     required this.bankName,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.version,
//   });

//   factory RedemptionData.fromJson(Map<String, dynamic> json) {
//     return RedemptionData(
//       id: json['_id'] ?? '',
//       user: json['user'] ?? '',
//       amount: (json['amount'] ?? 0).toDouble(),
//       accountHolderName: json['accountHolderName'] ?? '',
//       accountNumber: json['accountNumber'] ?? '',
//       ifscCode: json['ifscCode'] ?? '',
//       bankName: json['bankName'] ?? '',
//       status: json['status'] ?? 'Pending',
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       version: json['__v'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'user': user,
//       'amount': amount,
//       'accountHolderName': accountHolderName,
//       'accountNumber': accountNumber,
//       'ifscCode': ifscCode,
//       'bankName': bankName,
//       'status': status,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       '__v': version,
//     };
//   }
// }

// // Model for redemption history
// class RedemptionHistory {
//   final String id;
//   final String user;
//   final double amount;
//   final String accountHolderName;
//   final String accountNumber;
//   final String ifscCode;
//   final String bankName;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   RedemptionHistory({
//     required this.id,
//     required this.user,
//     required this.amount,
//     required this.accountHolderName,
//     required this.accountNumber,
//     required this.ifscCode,
//     required this.bankName,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory RedemptionHistory.fromJson(Map<String, dynamic> json) {
//     return RedemptionHistory(
//       id: json['_id'] ?? '',
//       user: json['user'] ?? '',
//       amount: (json['amount'] ?? 0).toDouble(),
//       accountHolderName: json['accountHolderName'] ?? '',
//       accountNumber: json['accountNumber'] ?? '',
//       ifscCode: json['ifscCode'] ?? '',
//       bankName: json['bankName'] ?? '',
//       status: json['status'] ?? 'Pending',
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'user': user,
//       'amount': amount,
//       'accountHolderName': accountHolderName,
//       'accountNumber': accountNumber,
//       'ifscCode': ifscCode,
//       'bankName': bankName,
//       'status': status,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }

//   // Helper method to get status color
//   Color getStatusColor() {
//     switch (status.toLowerCase()) {
//       case 'completed':
//       case 'success':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'failed':
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   // Helper method to get formatted status
//   String getFormattedStatus() {
//     return status.toUpperCase();
//   }
// }

// // Request model for redeem API
// class RedeemRequest {
//   final String accountHolderName;
//   final String accountNumber;
//   final String ifscCode;
//   final String bankName;

//   RedeemRequest({
//     required this.accountHolderName,
//     required this.accountNumber,
//     required this.ifscCode,
//     required this.bankName,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'accountHolderName': accountHolderName,
//       'accountNumber': accountNumber,
//       'ifscCode': ifscCode,
//       'bankName': bankName,
//     };
//   }

//   factory RedeemRequest.fromJson(Map<String, dynamic> json) {
//     return RedeemRequest(
//       accountHolderName: json['accountHolderName'] ?? '',
//       accountNumber: json['accountNumber'] ?? '',
//       ifscCode: json['ifscCode'] ?? '',
//       bankName: json['bankName'] ?? '',
//     );
//   }
// }









import 'dart:ui';

import 'package:flutter/material.dart';

class RedeemResponse {
  final String message;
  final RedemptionData redemption;

  RedeemResponse({
    required this.message,
    required this.redemption,
  });

  factory RedeemResponse.fromJson(Map<String, dynamic> json) {
    return RedeemResponse(
      message: json['message'] ?? '',
      redemption: RedemptionData.fromJson(json['redemption']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'redemption': redemption.toJson(),
    };
  }
}

class RedemptionData {
  final String id;
  final String user;
  final double amount;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String? upiId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  RedemptionData({
    required this.id,
    required this.user,
    required this.amount,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    this.upiId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory RedemptionData.fromJson(Map<String, dynamic> json) {
    return RedemptionData(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      bankName: json['bankName'] ?? '',
      upiId: json['upiId'],
      status: json['status'] ?? 'Pending',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'amount': amount,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      if (upiId != null) 'upiId': upiId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}

// Model for redemption history
class RedemptionHistory {
  final String id;
  final String user;
  final double amount;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String? upiId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  RedemptionHistory({
    required this.id,
    required this.user,
    required this.amount,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    this.upiId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RedemptionHistory.fromJson(Map<String, dynamic> json) {
    return RedemptionHistory(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      bankName: json['bankName'] ?? '',
      upiId: json['upiId'],
      status: json['status'] ?? 'Pending',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'amount': amount,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      if (upiId != null) 'upiId': upiId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method to get status color
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get formatted status
  String getFormattedStatus() {
    return status.toUpperCase();
  }
}

// Request model for redeem API
class RedeemRequest {
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String? upiId;

  RedeemRequest({
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    this.upiId,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      if (upiId != null) 'upiId': upiId,
    };
  }

  factory RedeemRequest.fromJson(Map<String, dynamic> json) {
    return RedeemRequest(
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      bankName: json['bankName'] ?? '',
      upiId: json['upiId'],
    );
  }
}