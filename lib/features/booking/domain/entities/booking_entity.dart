import 'package:equatable/equatable.dart';

enum BookingStatus { pending, approved, rejected, cancelled, completed }

class BookingEntity extends Equatable {
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
  final String? cafeName;
  final String? cafeLocation;

  const BookingEntity({
    this.id = '',
    this.userId = '',
    required this.cafeId,
    this.date,
    this.time,
    this.guests = 1,
    this.occasion,
    this.seatingPreference,
    this.status = BookingStatus.pending,
    this.createdAt,
    this.totalAmount = 50.0,
    this.reservationFee = 50.0,
    this.cafeName,
    this.cafeLocation,
  });


  BookingEntity copyWith({
    String? id,
    String? userId,
    String? cafeId,
    DateTime? date,
    String? time,
    int? guests,
    String? occasion,
    String? seatingPreference,
    BookingStatus? status,
    DateTime? createdAt,
    double? totalAmount,
    double? reservationFee,
    String? cafeName,
    String? cafeLocation,
  }) {
    return BookingEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cafeId: cafeId ?? this.cafeId,
      date: date ?? this.date,
      time: time ?? this.time,
      guests: guests ?? this.guests,
      occasion: occasion ?? this.occasion,
      seatingPreference: seatingPreference ?? this.seatingPreference,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      totalAmount: totalAmount ?? this.totalAmount,
      reservationFee: reservationFee ?? this.reservationFee,
      cafeName: cafeName ?? this.cafeName,
      cafeLocation: cafeLocation ?? this.cafeLocation,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    cafeId,
    date,
    time,
    guests,
    occasion,
    seatingPreference,
    status,
    createdAt,
    totalAmount,
    reservationFee,
    cafeName,
    cafeLocation,
  ];
}
