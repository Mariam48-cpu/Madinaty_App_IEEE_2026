import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/booking/data/models/booking_model.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/repositories/booking_repository_interface.dart';

@LazySingleton(as: BookingRepositoryInterface)
class BookingRepositoryImpl implements BookingRepositoryInterface {
  final FirebaseFirestore firestore;

  BookingRepositoryImpl({
    FirebaseFirestore? firestore,
  }) : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> bookings() {
    return firestore.collection('bookings');
  }

  @override
  Future<String> createBooking(BookingEntity booking) async {
    if (booking.date == null) {
      throw Exception('من فضلك اختار تاريخ الحجز');
    }

    if (booking.time == null || booking.time!.isEmpty) {
      throw Exception('من فضلك اختار وقت الحجز');
    }

    if (booking.cafeId.isEmpty) {
      throw Exception('بيانات الكافيه غير موجودة');
    }

    if (booking.userId.isEmpty) {
      throw Exception('المستخدم غير مسجل الدخول');
    }

    final dateKey =
        '${booking.date!.year}-'
        '${booking.date!.month.toString().padLeft(2, '0')}-'
        '${booking.date!.day.toString().padLeft(2, '0')}';

    final timeKey = booking.time!
        .replaceAll(' ', '_')
        .replaceAll(':', '-');

    final seatingKey = (booking.seatingPreference ?? 'any')
        .replaceAll(' ', '_');

    final bookingId =
        '${booking.cafeId}_${dateKey}_${timeKey}_$seatingKey';

    final bookingRef = bookings().doc(bookingId);

    // Check if this slot is already booked.
    final existingBooking = await bookingRef.get();

    if (existingBooking.exists) {
      final data = existingBooking.data();
      final status = data?['status'];

      if (status == 'pending' || status == 'approved') {
        throw Exception(
          'الطاولة دي محجوزة بالفعل في الوقت والتاريخ المحددين',
        );
      }
    }

    final bookingModel = BookingModel(
      id: bookingId,
      userId: booking.userId,
      cafeId: booking.cafeId,
      date: booking.date,
      time: booking.time,
      guests: booking.guests,
      occasion: booking.occasion,
      seatingPreference: booking.seatingPreference,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    await bookingRef.set(
      bookingModel.toFirestore(),
    );

    return bookingId;
  }

  @override
  Future<BookingEntity?> getBooking(String bookingId) async {
    final doc = await bookings().doc(bookingId).get();

    if (!doc.exists) {
      return null;
    }

    final bookingModel = BookingModel.fromFirestore(doc);

    return bookingModel.toEntity();
  }

  @override
  Future<void> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
    await bookings().doc(bookingId).update({
      'status': status.name,
    });
  }
}
