import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/booking_entity.dart';

abstract class CalendarHelper {
  static Future<void> addBookingToCalendar({
    required BookingEntity booking,
    String cafeName = 'مدينتي كافيه',
    String cafeLocation = 'التجمع الخامس',
  }) async {
    final DateTime startDate = booking.date?? DateTime.now();
    final DateTime endDate = startDate.add(const Duration(hours: 2));

    final String startIso = startDate
        .toUtc()
        .toIso8601String()
        .replaceAll(RegExp(r'[:-]'), '')
        .split('.')
        .first + 'Z';
    final String endIso = endDate
        .toUtc()
        .toIso8601String()
        .replaceAll(RegExp(r'[:-]'), '')
        .split('.')
        .first + 'Z';

    final String shortId = booking.id.isNotEmpty && booking.id.length >= 8
        ? booking.id.substring(0, 8).toUpperCase()
        : booking.id;

    final Uri googleCalendarUrl = Uri.https(
      'calendar.google.com',
      '/calendar/render',
      {
        'action': 'TEMPLATE',
        'text': 'حجز طاولة - $cafeName',
        'dates': '$startIso/$endIso',
        'details': 'حجز طاولة لـ ${booking.guests} أشخاص • رقم الحجز: #$shortId',
        'location': cafeLocation,
      },
    );

    try {
      await launchUrl(
        googleCalendarUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Error launching calendar: $e');
    }
  }
}