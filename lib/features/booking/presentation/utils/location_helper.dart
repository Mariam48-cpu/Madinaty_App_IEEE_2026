import 'package:url_launcher/url_launcher.dart';

abstract class MapLauncherHelper {
  static Future<void> openMapDirections({
    double? latitude,
    double? longitude,
    String? cafeLocationName,
  }) async {
    final Uri uri;

    if (latitude != null && longitude != null) {
      uri = Uri.parse('google.navigation:q=$latitude,$longitude&mode=d');
    } else {
      final query = Uri.encodeComponent(cafeLocationName ?? 'روستري لاب التجمع الخامس');
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final webFallback = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(cafeLocationName ?? "كافيه")}',
      );
      await launchUrl(webFallback, mode: LaunchMode.externalApplication);
    }
  }
}