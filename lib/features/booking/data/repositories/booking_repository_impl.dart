import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/features/booking/data/models/booking_model.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/repositories/booking_repository_interface.dart';

@LazySingleton(as: BookingRepositoryInterface)
class BookingRepositoryImpl implements BookingRepositoryInterface {
  final FirebaseFirestore firestore;

  BookingRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> bookings() {
    return firestore.collection('bookings');
  }

  @override
  Future<String> createBooking(BookingEntity booking) async {
    if (booking.date == null) {
      throw Exception(AppLocale.selectDateError);
    }

    if (booking.time == null || booking.time!.trim().isEmpty) {
      throw Exception(AppLocale.selectTimeError);
    }

    if (booking.cafeId.trim().isEmpty) {
      throw Exception(AppLocale.cafeDataNotFoundError);
    }

    if (booking.userId.trim().isEmpty) {
      throw Exception(AppLocale.userNotLoggedInError);
    }

    final dateKey =
        '${booking.date!.year}-'
        '${booking.date!.month.toString().padLeft(2, '0')}-'
        '${booking.date!.day.toString().padLeft(2, '0')}';

    final timeKey = _normalizeKeyPart(booking.time!);

    final seatingKey = _normalizeKeyPart(booking.seatingPreference ?? 'any');

    final bookingId =
        '${booking.cafeId.trim()}_'
        '${dateKey}_'
        '${timeKey}_'
        '${seatingKey}';

    final bookingRef = bookings().doc(bookingId);

    final bookingModel = BookingModel(
      id: bookingId,
      userId: booking.userId,
      cafeId: booking.cafeId,
      cafeName: booking.cafeName,
      cafeLocation: booking.cafeLocation,
      date: booking.date,
      time: booking.time,
      guests: booking.guests,
      occasion: booking.occasion,
      seatingPreference: booking.seatingPreference,
      status: booking.status,
      createdAt: DateTime.now(),
      totalAmount: booking.totalAmount,
      reservationFee: booking.reservationFee,
    );

    await firestore.runTransaction((transaction) async {
      final existing = await transaction.get(bookingRef);

      if (existing.exists) {
        final data = existing.data();

        final status = data?['status']?.toString();

        if (status == BookingStatus.pending.name ||
            status == BookingStatus.approved.name) {
          throw Exception(AppLocale.tableAlreadyBookedError);
        }
      }

      transaction.set(bookingRef, bookingModel.toFirestore());
    });

    /*
     * النقاط بعد نجاح الحجز فقط.
     */
    try {
      await firestore.collection('users').doc(booking.userId).set({
        'points': FieldValue.increment(50),
        'loyaltyPoints': FieldValue.increment(50),
      }, SetOptions(merge: true));
    } catch (_) {}

    return bookingId;
  }

  String _normalizeKeyPart(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(':', '-')
        .replaceAll('/', '-')
        .replaceAll('\\', '-');
  }

  @override
  Future<BookingEntity?> getBooking(String bookingId) async {
    final doc = await bookings().doc(bookingId).get();

    if (!doc.exists) {
      return null;
    }

    return BookingModel.fromFirestore(doc).toEntity();
  }

  @override
  Future<List<BookingEntity>> getUserBookings(String userId) async {
    if (userId.isEmpty) {
      return [];
    }

    try {
      final snapshot = await bookings()
          .where('userId', isEqualTo: userId)
          .get();

      final list = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc).toEntity())
          .toList();

      list.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

        return bDate.compareTo(aDate);
      });

      return list;
    } catch (_) {
      return [];
    }
  }

  @override
  Stream<List<BookingEntity>> watchUserBookings(String userId) {
    if (userId.isEmpty) {
      return Stream.value([]);
    }

    try {
      return bookings()
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
            final list = snapshot.docs
                .map((doc) => BookingModel.fromFirestore(doc).toEntity())
                .toList();

            list.sort((a, b) {
              final aDate =
                  a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

              final bDate =
                  b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

              return bDate.compareTo(aDate);
            });

            return list;
          })
          .handleError((_) => <BookingEntity>[]);
    } catch (_) {
      return Stream.value([]);
    }
  }

  @override
  Future<void> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
    await bookings().doc(bookingId).update({'status': status.name});
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await updateBookingStatus(
      bookingId: bookingId,
      status: BookingStatus.cancelled,
    );
  }
}