import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/use_cases/create_booking_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/use_cases/get_booking_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/use_cases/update_booking_status_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/notifications/domain/use_cases/create_notification_use_case.dart';

import 'booking_state.dart';

@injectable
class BookingCubit extends Cubit<BookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final GetBookingUseCase getBookingUseCase;
  final UpdateBookingStatusUseCase updateBookingStatusUseCase;
  final CreateNotificationUseCase createNotificationUseCase;

  BookingCubit(
      this.createBookingUseCase,
      this.getBookingUseCase,
      this.updateBookingStatusUseCase,
      this.createNotificationUseCase,
      ) : super(BookingInitial());

  String? cafeId;
  DateTime? date;
  String? time;
  int guests = 1;
  String? occasion;
  String? seatingPreference;

  String? bookingId;

  void setCafeId(String id) {
    cafeId = id;
    emit(BookingInitial());
  }

  void selectDate(DateTime selectedDate) {
    date = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    emit(BookingInitial());
  }

  void selectTime(String selectedTime) {
    time = selectedTime;

    emit(BookingInitial());
  }

  void incrementGuests() {
    if (guests >= 10) return;

    guests++;
    emit(BookingInitial());
  }

  void decrementGuests() {
    if (guests <= 1) return;

    guests--;
    emit(BookingInitial());
  }

  void selectOccasion(String selectedOccasion) {
    occasion = selectedOccasion;

    emit(BookingInitial());
  }

  void selectSeatingPreference(String preference) {
    seatingPreference = preference;
  }

  bool validateDateTime() {
    return date != null &&
        time != null &&
        guests > 0;
  }

  bool validateBooking() {
    return cafeId != null &&
        cafeId!.isNotEmpty &&
        date != null &&
        time != null &&
        time!.isNotEmpty &&
        guests > 0 &&
        occasion != null &&
        occasion!.isNotEmpty &&
        seatingPreference != null &&
        seatingPreference!.isNotEmpty;
  }

  Future<void> createBooking() async {
    if (!validateBooking()) {
      emit(
        BookingFailure(
          'complete_booking_data_error',
        ),
      );
      return;
    }

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(
        BookingFailure(
          'login_required_booking_error',
        ),
      );
      return;
    }

    emit(BookingLoading());

    try {
      final booking = BookingEntity(
        id: '',
        userId: user.uid,
        cafeId: cafeId!,
        date: date!,
        time: time!,
        guests: guests,
        occasion: occasion!,
        seatingPreference: seatingPreference!,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
      );

      bookingId =
      await createBookingUseCase(booking);

      emit(
        BookingSuccess(bookingId!),
      );
    } catch (e) {
      emit(
        BookingFailure(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  Future<BookingEntity?> getBooking(
      String id,
      ) async {
    try {
      return await getBookingUseCase(id);
    } catch (e) {
      emit(
        BookingFailure(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );

      return null;
    }
  }

  Future<void> updateBookingStatus({
    required String id,
    required BookingStatus status,
  }) async {
    emit(BookingLoading());

    try {
      await updateBookingStatusUseCase(
        bookingId: id,
        status: status,
      );

      if (status == BookingStatus.completed) {
        final booking =
        await getBookingUseCase(id);

        if (booking != null &&
            booking.userId.isNotEmpty) {
          final notificationResult =
          await createNotificationUseCase(
            uid: booking.userId,
            title: 'Booking Completed',
            body:
            'Your booking has been completed successfully.',
            type: 'booking_completed',
            bookingId: id,
          );

          notificationResult.fold(
                (failure) {
            },
                (_) {},
          );
        }
      }

      emit(
        BookingSuccess(id),
      );
    } catch (e) {
      emit(
        BookingFailure(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
}