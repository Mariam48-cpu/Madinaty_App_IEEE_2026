import 'dart:math' as math;

import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import 'package:madinaty_app_ieee_2026/core/services/location_service.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/menu_category_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/repositories/cafe_repository_interface.dart'
    as cafe_repo;
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/repositories/cafe_repository_interface.dart';

import '../../../../core/localization/app_locale.dart';
import '../../domain/entities/ai_plan_entity.dart';
import '../../domain/repositories/ai_planner_repository.dart';
import '../datasources/ai_planner_data_source.dart';
import '../datasources/weather_data_source.dart';

@LazySingleton(as: AIPlannerRepository)
class AIPlannerRepositoryImpl implements AIPlannerRepository {
  final AIPlannerDataSource aiDataSource;
  final WeatherDataSource weatherDataSource;
  final CafeRepositoryInterface discoveryRepository;
  final cafe_repo.CafeeRepositoryInterface cafeRepository;
  final LocationService locationService;

  AIPlannerRepositoryImpl({
    required this.aiDataSource,
    required this.weatherDataSource,
    required this.discoveryRepository,
    required this.cafeRepository,
    required this.locationService,
  });

  @override
  Future<AIPlanEntity> createPlan(AIPlanRequestEntity request) async {
    final position = request.latitude != null && request.longitude != null
        ? LatLng(request.latitude!, request.longitude!)
        : await _getLocation();

    if (position == null) {
      throw Exception(AppLocale.locationError);
    }

    final intent = await aiDataSource.understandRequest(
      message: request.message,
      budget: request.budget,
      durationHours: request.durationHours,
      interests: request.interests,
      mood: request.mood,
      occasion: request.occasion,
    );

    final weather = await weatherDataSource.getCurrentWeather(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    final weatherText = AppLocale.AR[weather.summaryKey] ?? AppLocale.weatherUnavailable;


    final nearby = await discoveryRepository.getNearbyCafes(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    if (nearby.isEmpty) {
      throw Exception(AppLocale.noNearbyPlacesAvailable);
    }


    final preRanked = _preRank(nearby, intent.requirements, position);

    final candidates = await _buildCandidates(
      preRanked.take(10).toList(),
      intent.budget,
    );

    if (candidates.isEmpty) {
      throw Exception(
          AppLocale.noMatchingCafesFound
      );
    }


    final finalDto = await aiDataSource.rankCandidates(
      intent: intent,
      candidates: candidates,
      weatherSummary:
          '${weather.temperature.toStringAsFixed(0)}°C. '
          '${weatherText}',
    );


    final byId = {for (final cafe in preRanked) cafe.id: cafe};

    final activities = <AIPlanActivityEntity>[];

    for (final dto in finalDto.activities) {
      final cafe = byId[dto.placeId];

      if (cafe == null) continue;

      Map<String, dynamic>? candidate;

      for (final item in candidates) {
        if (item['placeId'] == cafe.id) {
          candidate = item;
          break;
        }
      }

      activities.add(
        AIPlanActivityEntity(
          title: dto.title,
          purpose: dto.purpose,
          category: dto.category,
          requirements: intent.requirements,
          durationMinutes: dto.durationMinutes,
          place: AIPlanPlaceEntity(
            id: cafe.id,
            name: cafe.name,
            address: cafe.address,
            rating: cafe.rating,
            reviewsCount: cafe.reviewsCount,
            isOpen: cafe.isOpen,
            openingHours: cafe.openingHours,
            attributes: cafe.attributes,
            photos: cafe.photos,
            location: cafe.location,
            distanceMeters: _distanceMeters(position, cafe),
            estimatedCost:
                (candidate?['estimatedCost'] as num?)?.toDouble() ?? 0,
            matchScore: dto.matchScore,
            reason: dto.reason,
          ),
        ),
      );
    }


    if (activities.isEmpty) {
      final fallback = preRanked.first;

      double fallbackCost = 0;

      if (candidates.isNotEmpty) {
        fallbackCost =
            (candidates.first['estimatedCost'] as num?)?.toDouble() ?? 0;
      }

      activities.add(
        AIPlanActivityEntity(
          title: AppLocale.suitableCafeForYou,
          purpose: intent.mood.isEmpty ? AppLocale.chillSitting : intent.mood,
          category: 'cafe',
          requirements: intent.requirements,
          durationMinutes: request.durationHours * 60 < 45
              ? 45
              : request.durationHours * 60,
          place: AIPlanPlaceEntity(
            id: fallback.id,
            name: fallback.name,
            address: fallback.address,
            rating: fallback.rating,
            reviewsCount: fallback.reviewsCount,
            isOpen: fallback.isOpen,
            openingHours: fallback.openingHours,
            attributes: fallback.attributes,
            photos: fallback.photos,
            location: fallback.location,
            distanceMeters: _distanceMeters(position, fallback),
            estimatedCost: fallbackCost,
            matchScore: 80,
            reason:
            AppLocale.nearbyRecommendation
          ),
        ),
      );
    }


    final uniquePlaces = <String, AIPlanPlaceEntity>{
      for (final activity in activities)
        if (activity.place != null) activity.place!.id: activity.place!,
    };

    final calculatedTotal = uniquePlaces.values
        .map((place) => place.estimatedCost)
        .where((cost) => cost > 0)
        .fold<double>(0, (sum, cost) => sum + cost);

    return AIPlanEntity(
      headline: finalDto.headline,
      summary: finalDto.summary,
      estimatedTotal: calculatedTotal > 0
          ? calculatedTotal
          : finalDto.estimatedTotal,
      budget: request.budget,
      weatherSummary:
          '${weather.temperature.toStringAsFixed(0)}°C '
          '• ${weatherText}',
      activities: activities,
    );
  }



  Future<LatLng?> _getLocation() async {
    final position = await locationService.getCurrentLocation();

    if (position == null) {
      return null;
    }

    return LatLng(position.latitude, position.longitude);
  }



  List<CafeEntity> _preRank(
    List<CafeEntity> cafes,
    List<String> requirements,
    LatLng origin,
  ) {
    final required = requirements.map(_normalize).toList();

    final distance = const Distance();

    final scored = cafes.map((cafe) {
      final haystack = _normalize(
        [
          cafe.name,
          cafe.description,
          cafe.address,
          ...cafe.attributes,
        ].join(' '),
      );

      var score = cafe.rating * 10;

      for (final requirement in required) {
        if (haystack.contains(requirement)) {
          score += 18;
        }
      }

      if (cafe.isOpen) {
        score += 8;
      }

      final meters = distance.as(LengthUnit.Meter, origin, cafe.location);

      score += math.max(0, 12 - meters / 1000);

      return MapEntry(cafe, score);
    }).toList();

    scored.sort((a, b) => b.value.compareTo(a.value));

    return scored.map((entry) => entry.key).toList();
  }



  Future<List<Map<String, dynamic>>> _buildCandidates(
    List<CafeEntity> cafes,
    double budget,
  ) async {
    final result = <Map<String, dynamic>>[];

    for (final cafe in cafes) {
      double estimatedCost = 0;

      try {
        final menu = await cafeRepository.getCafeMenu(cafe.id);

        estimatedCost = _estimateCost(menu);
      } catch (_) {

      }

      result.add({
        'placeId': cafe.id,
        'name': cafe.name,
        'rating': cafe.rating,
        'reviewsCount': cafe.reviewsCount,
        'address': cafe.address,
        'isOpen': cafe.isOpen,
        'attributes': cafe.attributes,
        'description': cafe.description,
        'estimatedCost': estimatedCost,
        'withinBudget': estimatedCost <= 0 || estimatedCost <= budget,
      });
    }

    return result;
  }



  double _estimateCost(List<MenuCategoryEntity> categories) {
    final prices = categories
        .expand((category) => category.products)
        .map((product) => product.price)
        .where((price) => price > 0)
        .toList();

    if (prices.isEmpty) {
      return 0;
    }

    prices.sort();

    final take = math.min(5, prices.length);

    final selected = prices.take(take).toList();

    return selected.reduce((a, b) => a + b);
  }


  double _distanceMeters(LatLng origin, CafeEntity cafe) {
    return const Distance().as(LengthUnit.Meter, origin, cafe.location);
  }


  String _normalize(String value) {
    return value.toLowerCase().replaceAll('-', ' ').trim();
  }
}
