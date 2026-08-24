import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/data/models/cafe_dto.dart';

@injectable
class GooglePlacesDataSource {
  static const String apiKey = 'AIzaSyAUyp5BGoG23a36VGYfbxyC_Dg7P9jDmY4';

  static const String baseUrl = 'https://places.googleapis.com/v1/';

  static const String placesFieldMask =
      'places.id,'
      'places.displayName,'
      'places.location,'
      'places.rating,'
      'places.userRatingCount,'
      'places.formattedAddress,'
      'places.currentOpeningHours';

  Map<String, String> headers() => {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': apiKey,
    'X-Goog-FieldMask': placesFieldMask,
  };

  Future<List<CafeDto>> getCafesForLocation({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
    int targetCount = 30,
  }) async {
    final result = <CafeDto>[];
    final seen = <String>{};
    final nearby = await getNearbyCafes(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radiusInMeters,
    );

    addUnique(result, seen, nearby, targetCount);

    if (result.length < targetCount) {
      final queries = <String>['cafes', 'coffee shops', 'coffee'];

      for (final query in queries) {
        if (result.length >= targetCount) break;

        final found = await searchCafesNearLocation(
          query: query,
          latitude: latitude,
          longitude: longitude,
          radiusInMeters: radiusInMeters,
        );

        addUnique(result, seen, found, targetCount);
      }
    }

    return result.take(targetCount).toList(growable: false);
  }

  Future<List<CafeDto>> getNearbyCafes({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  }) async {
    final response = await http.post(
      Uri.parse('${baseUrl}places:searchNearby'),
      headers: headers(),
      body: jsonEncode({
        'includedTypes': ['cafe'],
        'maxResultCount': 20,
        'rankPreference': 'DISTANCE',
        'locationRestriction': {
          'circle': {
            'center': {'latitude': latitude, 'longitude': longitude},
            'radius': radiusInMeters,
          },
        },
      }),
    );

    return parseResponse(response, 'nearby cafes');
  }

  Future<List<CafeDto>> searchCafesNearLocation({
    required String query,
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  }) async {
    final response = await http.post(
      Uri.parse('${baseUrl}places:searchText'),
      headers: headers(),
      body: jsonEncode({
        'textQuery': query,
        'includedType': 'cafe',
        'maxResultCount': 20,
        'locationBias': {
          'circle': {
            'center': {'latitude': latitude, 'longitude': longitude},
            'radius': radiusInMeters,
          },
        },
      }),
    );

    return parseResponse(response, 'cafe search');
  }

  Future<CafeDto?> getCafeDetails(String placeId) async {
    final resourceName = placeId.startsWith('places/')
        ? placeId
        : 'places/$placeId';

    final response = await http.get(
      Uri.parse('$baseUrl$resourceName'),
      headers: {
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask':
            'id,'
            'displayName,'
            'location,'
            'rating,'
            'userRatingCount,'
            'formattedAddress,'
            'currentOpeningHours',
      },
    );

    if (response.statusCode == 404) {
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get cafe details: '
        '${response.statusCode}',
      );
    }

    return CafeDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  void addUnique(
    List<CafeDto> target,
    Set<String> seen,
    Iterable<CafeDto> source,
    int targetCount,
  ) {
    for (final cafe in source) {
      if (cafe.id.isEmpty) continue;
      if (seen.contains(cafe.id)) continue;

      seen.add(cafe.id);
      target.add(cafe);

      if (target.length >= targetCount) {
        return;
      }
    }
  }

  List<CafeDto> parseResponse(http.Response response, String operation) {
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get $operation: '
        '${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final places = data['places'] as List? ?? [];

    return places
        .whereType<Map<String, dynamic>>()
        .map(CafeDto.fromJson)
        .toList();
  }
}
