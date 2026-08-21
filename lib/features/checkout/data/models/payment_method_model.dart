import '../../domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.title,
    required super.type,
    super.isSelected,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: _mapStringToPaymentType(map['type'] ?? 'card'),
      isSelected: map['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'isSelected': isSelected,
    };
  }

  static PaymentType _mapStringToPaymentType(String type) {
    switch (type) {
      case 'wallet':
        return PaymentType.wallet;
      case 'cashOnArrival':
        return PaymentType.cashOnArrival;
      case 'card':
      default:
        return PaymentType.card;
    }
  }
}
