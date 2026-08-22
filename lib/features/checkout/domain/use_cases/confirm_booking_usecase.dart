import 'package:madinaty_app_ieee_2026/features/checkout/domain/repositories/payment_repo_interface.dart';

import '../../../booking/data/models/booking_model.dart';

class ConfirmBookingUseCase {
  final PaymentRepoInterface repo;

  ConfirmBookingUseCase(this.repo);

  Future<BookingModel> call(BookingModel booking) async {
    return await repo.confirmBooking(booking);
  }
}
