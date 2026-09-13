import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';

abstract class BookingRepositoryInterface {
  Future<String> createBooking(BookingEntity booking);

  Future<BookingEntity?> getBooking(String bookingId);

  Future<List<BookingEntity>> getUserBookings(String userId);

  Stream<List<BookingEntity>> watchUserBookings(String userId);

  Future<void> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  });

  Future<void> cancelBooking(String bookingId);
}
