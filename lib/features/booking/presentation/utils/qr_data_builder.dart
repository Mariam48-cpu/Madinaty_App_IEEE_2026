import 'dart:convert';

import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';

class QrDataBuilder {
  String buildQrData(BookingEntity booking){

    Map<String,dynamic> book={
      'bookingId': booking.id,
    'userId':booking.userId,
    'cafeId':booking.cafeId,
    'date':booking.date!.toIso8601String(),
    'time':booking.time,
    'guests':booking.guests,
    'occasion':booking.occasion,
    'seatingPreference':booking.seatingPreference,
    "status":booking.status.name
    };
    return jsonEncode(book);
  }
}