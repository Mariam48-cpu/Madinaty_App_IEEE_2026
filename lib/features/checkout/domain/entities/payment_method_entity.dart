enum PaymentType { card, wallet, cashOnArrival }

class PaymentMethodEntity {
  final String id;
  final String title;
  final String? subtitle;
  final PaymentType type;
  final bool isSelected;

  const PaymentMethodEntity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.type,
    this.isSelected = false,
  });

  static const List<PaymentMethodEntity> availableMethods = [
    PaymentMethodEntity(
      id: 'card',
      title: 'بطاقة ائتمان / خصم مباشر',
      subtitle: 'فيزا، ماستركارد، ميزة',
      type: PaymentType.card,
    ),
    PaymentMethodEntity(
      id: 'wallet',
      title: 'محفظة رقمية',
      subtitle: 'فودافون كاش، إنستاباي، وغيرها',
      type: PaymentType.wallet,
    ),
    PaymentMethodEntity(
      id: 'cash',
      title: 'الدفع عند الوصول للكافيه',
      subtitle: 'نقداً أو عبر نقاط البيع المتاحة بالكافيه',
      type: PaymentType.cashOnArrival,
    ),
  ];
}

class WalletPaymentDetails {
  final String phoneNumber;

  const WalletPaymentDetails({required this.phoneNumber});
}
