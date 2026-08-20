import 'package:injectable/injectable.dart';

import '../entities/booking_entity.dart';
import '../repositories/booking_repository_interface.dart';

@injectable
class GetBookingUseCase {
  final BookingRepositoryInterface repository;

  GetBookingUseCase(this.repository);

  Future<BookingEntity?> call(String bookingId) {
    return repository.getBooking(bookingId);
  }
}