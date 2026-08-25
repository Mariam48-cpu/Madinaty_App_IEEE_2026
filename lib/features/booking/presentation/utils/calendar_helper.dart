import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/booking_entity.dart';

abstract class CalendarHelper {
  static Future<void> addBookingToCalendar({
    required BuildContext context,
    required BookingEntity booking,
    String? cafeName,
    String? cafeLocation,
  }) async {
    final String resolvedCafeName =
        cafeName ?? AppLocale.defaultCafeName.getString(context);
    final String resolvedCafeLocation =
        cafeLocation ?? AppLocale.defaultCafeLocation.getString(context);

    final DateTime startDate = booking.date ?? DateTime.now();
    final DateTime endDate = startDate.add(const Duration(hours: 2));

    final String startIso = startDate
        .toUtc()
        .toIso8601String()
        .replaceAll(RegExp(r'[:-]'), '')
        .split('.')
        .first +
        'Z';
    final String endIso = endDate
        .toUtc()
        .toIso8601String()
        .replaceAll(RegExp(r'[:-]'), '')
        .split('.')
        .first +
        'Z';

    final String shortId = booking.id.isNotEmpty && booking.id.length >= 8
        ? booking.id.substring(0, 8).toUpperCase()
        : booking.id;

    final String tableBookingPrefix =
    AppLocale.calendarTableBookingPrefix.getString(context);
    final String bookingForPrefix =
    AppLocale.calendarBookingForPrefix.getString(context);
    final String guestsText = AppLocale.guestsCountText.getString(context);
    final String bookingNumberPrefix =
    AppLocale.calendarBookingNumberPrefix.getString(context);

    final Uri googleCalendarUrl = Uri.https(
      'calendar.google.com',
      '/calendar/render',
      {
        'action': 'TEMPLATE',
        'text': '$tableBookingPrefix - $resolvedCafeName',
        'dates': '$startIso/$endIso',
        'details':
        '$bookingForPrefix ${booking.guests} $guestsText • $bookingNumberPrefix #$shortId',
        'location': resolvedCafeLocation,
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