import 'package:madinaty_app_ieee_2026/features/booking/data/models/booking_model.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/data/data_sources/payment_data_source_interface.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/domain/repositories/payment_repo_interface.dart';

class PaymentRepoImpl implements PaymentRepoInterface {
  final PaymentDataSourceInterface paymentDataSource;
  PaymentRepoImpl({required this.paymentDataSource});

  @override
  Future<String> getPaymobUrl({
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
  }) async {
    return await paymentDataSource.getPaymobPaymentUrl(
      amount: amount,
      userEmail: userEmail,
      userPhone: userPhone,
      userName: userName,
    );
  }

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    return const [
      PaymentMethodEntity(
        id: 'card',
        title: 'بطاقة ائتمان / خصم مباشر',
        type: PaymentType.card,
        isSelected: true,
      ),
      PaymentMethodEntity(
        id: 'wallet',
        title: 'محفظة رقمية',
        type: PaymentType.wallet,
        isSelected: false,
      ),
      PaymentMethodEntity(
        id: 'cash',
        title: 'دفع في الكافيه',
        type: PaymentType.cashOnArrival,
        isSelected: false,
      ),
    ];
  }

  @override
  Future<String> getPaymobWalletUrl({
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
    required String walletNumber,
  }) async {
    return await paymentDataSource.getPaymobWalletUrl(
      amount: amount,
      userEmail: userEmail,
      userPhone: userPhone,
      userName: userName,
      walletNumber: walletNumber,
    );
  }

  @override
  Future<BookingModel> confirmBooking(BookingModel booking) async {
    return await paymentDataSource.saveAndConfirmBooking(booking);
  }
}
