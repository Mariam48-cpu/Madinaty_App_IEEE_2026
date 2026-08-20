import 'package:injectable/injectable.dart';

import '../entities/booking_entity.dart';
import '../repositories/booking_repository_interface.dart';

@injectable
class UpdateBookingStatusUseCase {
  final BookingRepositoryInterface repository;

  UpdateBookingStatusUseCase(this.repository);

  Future<void> call({
    required String bookingId,
    required BookingStatus status,
  }) {
    return repository.updateBookingStatus(
      bookingId: bookingId,
      status: status,
    );
  }
}