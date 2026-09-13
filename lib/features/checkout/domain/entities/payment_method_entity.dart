import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

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

  static final List<PaymentMethodEntity> availableMethods = [
    PaymentMethodEntity(
      id: 'card',
      title: AppLocale.cardPaymentTitle,
      subtitle: AppLocale.cardPaymentSubtitle,
      type: PaymentType.card,
    ),
    const PaymentMethodEntity(
      id: 'wallet',
      title: AppLocale.walletPaymentTitle,
      subtitle: AppLocale.walletPaymentSubtitle,
      type: PaymentType.wallet,
    ),
    const PaymentMethodEntity(
      id: 'cash',
      title: AppLocale.cashPaymentTitle,
      subtitle: AppLocale.cashPaymentSubtitle,
      type: PaymentType.cashOnArrival,
    ),
  ];
}

class WalletPaymentDetails {
  final String phoneNumber;

  const WalletPaymentDetails({required this.phoneNumber});
}
