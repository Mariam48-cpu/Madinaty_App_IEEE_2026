import '../../../booking/data/models/booking_model.dart';

abstract class PaymentDataSourceInterface {
  Future<String> getPaymobPaymentUrl({
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

  Future<BookingModel> saveAndConfirmBooking(BookingModel booking);
}
