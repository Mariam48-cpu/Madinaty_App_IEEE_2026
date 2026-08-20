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
    );
  }

  factory BookingModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return BookingModel.fromMap(map, doc.id);
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookingModel(
      id: docId,
      userId: map['userId'] ?? '',
      cafeId: map['cafeId'] ?? '',
      date: map['date'] != null
          ? (map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.tryParse(map['date'].toString()))
          : null,
      time: map['time'],
      guests: (map['guests'] ?? 1).toInt(),
      occasion: map['occasion'],
      seatingPreference: map['seatingPreference'],
      status: BookingStatus.values.firstWhere(
            (e) => e.name == (map['status'] ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt'].toString()))
          : null,
    );
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
    };
  }

  BookingEntity toEntity() => this;
}