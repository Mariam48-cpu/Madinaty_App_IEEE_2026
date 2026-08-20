import '../../../booking/data/models/booking_model.dart';
import '../entities/payment_method_entity.dart';

abstract interface class PaymentRepoInterface {
  Future<String> getPaymobUrl({
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
  });

  Future<String> getPaymobWalletUrl({
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
    required String walletNumber,
  });

  Future<List<PaymentMethodEntity>> getPaymentMethods();
  Future<BookingModel> confirmBooking(BookingModel booking);
}
