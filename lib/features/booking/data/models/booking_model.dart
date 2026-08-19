import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';

class BookingModel {
  final String id;
  final String userId;
  final String cafeId;
  final DateTime date;
  final String time;
  final int guests;
  final String occasion;
  final String seatingPreference;
  final BookingStatus status;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.cafeId,
    required this.date,
    required this.time,
    required this.guests,
    required this.occasion,
    required this.seatingPreference,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return BookingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      cafeId: data['cafeId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      guests: data['guests'] ?? 1,
      occasion: data['occasion'] ?? '',
      seatingPreference: data['seatingPreference'] ?? '',
      status: BookingStatus.values.firstWhere(
        (status) => status.name == data['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'cafeId': cafeId,
      'date': Timestamp.fromDate(date),
      'time': time,
      'guests': guests,
      'occasion': occasion,
      'seatingPreference': seatingPreference,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      userId: entity.userId,
      cafeId: entity.cafeId,
      date: entity.date ?? DateTime.now(),
      time: entity.time ?? '',
      guests: entity.guests,
      occasion: entity.occasion ?? '',
      seatingPreference: entity.seatingPreference ?? '',
      status: entity.status,
      createdAt: entity.createdAt ?? DateTime.now(),
    );
  }

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      userId: userId,
      cafeId: cafeId,
      date: date,
      time: time,
      guests: guests,
      occasion: occasion,
      seatingPreference: seatingPreference,
      status: status,
      createdAt: createdAt,
    );
  }
}
