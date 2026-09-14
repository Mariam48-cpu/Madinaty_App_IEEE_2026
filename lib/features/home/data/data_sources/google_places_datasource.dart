import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../models/cafe_dto.dart';

@injectable
class GooglePlacesDataSource {
  final String apiKey = 'AIzaSyAUyp5BGoG23a36VGYfbxyC_Dg7P9jDmY4';

  String getPhotoUrl(String photoName) {
    return 'https://places.googleapis.com/v1/$photoName/media'
        '?maxHeightPx=400'
        '&maxWidthPx=400'
        '&key=$apiKey';
  }

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'places.id,'
          'places.displayName,'
          'places.location,'
          'places.rating,'
          'places.userRatingCount,'
          'places.formattedAddress,'
          'places.currentOpeningHours,'
          'places.photos',
    };
  }

  Future<List<CafeDto>> getNearbyCafes({
    required double latitude,
    required double longitude,
    double radiusMeters = 2000,
  }) async {
    final url = Uri.parse(
      'https://places.googleapis.com/v1/places:searchNearby',
    );

    final response = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode({
        'includedTypes': ['cafe'],
        'maxResultCount': 20,
        'locationRestriction': {
          'circle': {
            'center': {'latitude': latitude, 'longitude': longitude},
            'radius': radiusMeters,
          },
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get nearby cafes: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    final places = data['places'] as List? ?? [];

    return places
        .whereType<Map<String, dynamic>>()
        .map(CafeDto.fromJson)
        .toList();
  }

  Future<List<CafeDto>> searchCafes({
    required String query,
    double? latitude,
    double? longitude,
    double radiusMeters = 2000,
  }) async {
    final searchQuery = query.trim();

    if (searchQuery.isEmpty) {
      return [];
    }

    final url = Uri.parse('https://places.googleapis.com/v1/places:searchText');

    final body = <String, dynamic>{
      'textQuery': searchQuery,
      'includedType': 'cafe',
      'maxResultCount': 20,
    };

    /// مهم:
    ///
    /// locationBias يجعل Google يفضل النتائج القريبة،
    /// لكنه ليس فلترة صارمة للمسافة.
    ///
    /// الفلترة الحقيقية موجودة في RecommendationRepositoryImpl
    /// عن طريق حساب المسافة بين GPS المستخدم والكافيه.
    if (latitude != null && longitude != null) {
      body['locationBias'] = {
        'circle': {
          'center': {'latitude': latitude, 'longitude': longitude},
          'radius': radiusMeters,
        },
      };
    }

    final response = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search cafes: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    final places = data['places'] as List? ?? [];

    return places
        .whereType<Map<String, dynamic>>()
        .map(CafeDto.fromJson)
        .toList();
  }
}
