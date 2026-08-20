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
  });
}
