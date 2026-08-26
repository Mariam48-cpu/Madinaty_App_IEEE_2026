import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class MapLauncherHelper {
  static Future<void> openMapDirections({
    required BuildContext context,
    double? latitude,
    double? longitude,
    String? cafeLocationName,
  }) async {
    final Uri uri;

    final defaultLocation = AppLocale.defaultMapLocationName.getString(context);
    final fallbackLocation = AppLocale.defaultMapFallbackCafe.getString(context);

    if (latitude != null && longitude != null) {
      uri = Uri.parse('google.navigation:q=$latitude,$longitude&mode=d');
    } else {
      final query = Uri.encodeComponent(cafeLocationName ?? defaultLocation);
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final webFallback = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(cafeLocationName ?? fallbackLocation)}',
      );
      await launchUrl(webFallback, mode: LaunchMode.externalApplication);
    }
  }
}