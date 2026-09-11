import 'package:equatable/equatable.dart';

enum BookingStatus { pending, approved, rejected, cancelled, completed }

class BookingEntity extends Equatable {
  final String id;
  final String userId;
  final String cafeId;
  final String? cafeName;
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
    required this.cafeId,
    this.cafeName,
    this.date,
    this.time,
    this.guests = 1,
    this.occasion,
    this.seatingPreference,
    this.status = BookingStatus.pending,
    this.createdAt,
    this.totalAmount = 50.0,
    this.reservationFee = 50.0,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    cafeId,
    cafeName,
    date,
    time,
    guests,
    occasion,
    seatingPreference,
    status,
    createdAt,
    totalAmount,
    reservationFee,
  ];
}
