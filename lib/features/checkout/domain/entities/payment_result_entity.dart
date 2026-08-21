class PaymentResultEntity {
  final bool isSuccess;
  final String transactionId;
  final String message;
  final DateTime timestamp;

  const PaymentResultEntity({
    required this.isSuccess,
    required this.transactionId,
    required this.message,
    required this.timestamp,
  });
}
