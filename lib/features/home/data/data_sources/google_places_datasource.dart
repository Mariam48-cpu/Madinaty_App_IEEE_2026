import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../models/cafe_dto.dart';

@injectable
class GooglePlacesDataSource {
  final String apiKey = 'AIzaSyAUyp5BGoG23a36VGYfbxyC_Dg7P9jDmY4';

  String getPhotoUrl(String photoName) {
    return 'https://places.googleapis.com/v1/$photoName/media?maxHeightPx=400&maxWidthPx=400&key=$apiKey';
  }

  Future<List<CafeDto>> getNearbyCafes({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      'https://places.googleapis.com/v1/places:searchNearby',
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask':
            'places.id,places.displayName,places.location,places.rating,places.formattedAddress,places.currentOpeningHours,places.photos',
      },
      body: jsonEncode({
        'includedTypes': ['cafe'],
        'locationRestriction': {
          'circle': {
            'center': {'latitude': latitude, 'longitude': longitude},
            'radius': 5000.0,
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
        .map((place) => CafeDto.fromJson(place as Map<String, dynamic>))
        .toList();
  }

  Future<List<CafeDto>> searchCafes({required String query}) async {
    final url = Uri.parse('https://places.googleapis.com/v1/places:searchText');
    final response = await http.post(
      url,
      headers: {
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
      },
      body: jsonEncode({
        'textQuery': query,
        'includedType': 'cafe',
        'maxResultCount': 10,
      }),
    );
    if (response.statusCode != 200) {
      print('Google Places Search Error');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      throw Exception('Failed to search cafes: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    final places = data['places'] as List? ?? [];

    return places
        .map((place) => CafeDto.fromJson(place as Map<String, dynamic>))
        .toList();
  }
}