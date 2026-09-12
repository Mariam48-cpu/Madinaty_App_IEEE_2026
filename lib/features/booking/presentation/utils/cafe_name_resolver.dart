import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:http/http.dart' as http;

class CafeNameResolver {
  static final Map<String, String> _cache = {};
  static const String _apiKey = 'AIzaSyAUyp5BGoG23a36VGYfbxyC_Dg7P9jDmY4';

  static String? getCachedName(String cafeId) {
    if (cafeId.isEmpty) return null;
    return _cache[cafeId];
  }

  static Future<String> resolveCafeName(
    String cafeId, {
    String defaultFallback = 'حجز طاولة',
  }) async {
    if (cafeId.isEmpty) {
      return defaultFallback;
    }

    if (_cache.containsKey(cafeId)) {
      return _cache[cafeId]!;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('cafes')
          .doc(cafeId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final name = (data['name'] ?? data['displayName']) as String?;
        if (name != null && name.trim().isNotEmpty) {
          _cache[cafeId] = name.trim();
          return _cache[cafeId]!;
        }
      }
    } catch (_) {}

    try {
      final cleanId = cafeId.startsWith('places/')
          ? cafeId.replaceFirst('places/', '')
          : cafeId;
      final url = Uri.parse('https://places.googleapis.com/v1/places/$cleanId');
      final langCode =
          FlutterLocalization.instance.currentLocale?.languageCode ?? 'ar';

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'id,displayName',
          'Accept-Language': langCode,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final name = data['displayName']?['text'] as String?;
        if (name != null && name.trim().isNotEmpty) {
          _cache[cafeId] = name.trim();
          return _cache[cafeId]!;
        }
      }
    } catch (_) {}

    return defaultFallback;
  }
}
