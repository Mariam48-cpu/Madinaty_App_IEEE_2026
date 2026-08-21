import 'package:injectable/injectable.dart';

import '../entities/booking_entity.dart';
import '../repositories/booking_repository_interface.dart';

@injectable
class CreateBookingUseCase {
  final BookingRepositoryInterface repository;

  CreateBookingUseCase(this.repository);

  Future<String> call(BookingEntity booking) {
    return repository.createBooking(booking);
  }
}