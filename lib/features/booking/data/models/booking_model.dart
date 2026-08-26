import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    super.id,
    super.userId,
    required super.cafeId,
    super.date,
    super.time,
    super.guests,
    super.occasion,
    super.seatingPreference,
    super.status,
    super.createdAt,
    super.totalAmount,
    super.reservationFee,
  });

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      userId: entity.userId,
      cafeId: entity.cafeId,
      date: entity.date,
      time: entity.time,
      guests: entity.guests,
      occasion: entity.occasion,
      seatingPreference: entity.seatingPreference,
      status: entity.status,
      createdAt: entity.createdAt,
      totalAmount: entity.totalAmount,
      reservationFee: entity.reservationFee,
    );
  }

  factory BookingModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final map = doc.data() ?? {};
    return BookingModel.fromMap(map, doc.id);
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookingModel(
      id: docId,
      userId: map['userId'] as String? ?? '',
      cafeId: map['cafeId'] as String? ?? '',
      date: _parseDate(map['date']),
      time: map['time'] as String?,
      guests: (map['guests'] ?? 1).toInt(),
      occasion: map['occasion'] as String?,
      seatingPreference: map['seatingPreference'] as String?,
      status: BookingStatus.values.firstWhere(
            (e) => e.name == (map['status'] ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      createdAt: _parseDate(map['createdAt']),
      totalAmount: (map['totalAmount'] ?? 50.0).toDouble(),
      reservationFee: (map['reservationFee'] ?? 50.0).toDouble(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cafeId': cafeId,
      'date': date?.toIso8601String(),
      'time': time,
      'guests': guests,
      'occasion': occasion,
      'seatingPreference': seatingPreference,
      'status': status.name,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'totalAmount': totalAmount,
      'reservationFee': reservationFee,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'cafeId': cafeId,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'time': time,
      'guests': guests,
      'occasion': occasion,
      'seatingPreference': seatingPreference,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
      'totalAmount': totalAmount,
      'reservationFee': reservationFee,
    };
  }

  BookingEntity toEntity() => this;
}
