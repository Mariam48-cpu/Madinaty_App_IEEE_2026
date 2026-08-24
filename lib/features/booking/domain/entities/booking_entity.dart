enum BookingStatus { pending, approved, rejected, cancelled }

class BookingEntity {
  final String id;
  final String userId;
  final String cafeId;
  final DateTime? date;
  final String? time;
  final int guests;
  final String? occasion;
  final String? seatingPreference;
  final BookingStatus status;
  final DateTime? createdAt;
  final double totalAmount;
  final double reservationFee;

  const BookingEntity({
    this.id = '',
    this.userId = '',
    this.date,
    this.time,
    this.guests = 1,
    this.occasion,
    this.seatingPreference,
    this.status = BookingStatus.pending,
    this.createdAt, required this.cafeId,
    this.totalAmount = 50.0,
    this.reservationFee = 50.0,
  });
}
