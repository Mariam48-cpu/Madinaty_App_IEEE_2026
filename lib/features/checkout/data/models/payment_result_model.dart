import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentResultModel {
  final bool isSuccess;
  final String transactionId;
  final String message;
  final DateTime timestamp;

  const PaymentResultModel({
    required this.isSuccess,
    required this.transactionId,
    required this.message,
    required this.timestamp,
  });

  factory PaymentResultModel.fromMap(Map<String, dynamic> map) {
    return PaymentResultModel(
      isSuccess: map['isSuccess'] ?? false,
      transactionId: map['transactionId'] ?? '',
      message: map['message'] ?? '',
      timestamp: _parseDateTime(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isSuccess': isSuccess,
      'transactionId': transactionId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }
}
