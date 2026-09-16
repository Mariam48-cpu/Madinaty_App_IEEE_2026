import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';

import '../../../personalization/domain/use_cases/get_user_preferences_usecase.dart';
import '../../domain/entities/cafe_recommendation_entity.dart';
import '../../domain/use_cases/get_recommendations_use_case.dart';
import '../../domain/use_cases/search_cafes_use_case.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetRecommendationsUseCase getRecommendationsUseCase;
  final GetUserPreferencesUseCase getUserPreferencesUseCase;
  final SearchCafesUseCase searchCafesUseCase;

  final String currentUserId;

  Timer? _searchDebounce;

     int _homeRequestId = 0;

  HomeCubit({
    required this.getRecommendationsUseCase,
    required this.getUserPreferencesUseCase,
    required this.searchCafesUseCase,
    @factoryParam required this.currentUserId,
  }) : super(const HomeInitial());

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Future<void> fetchHomeData({
    String? categoryFilter,
    LatLng? userLocation,
  }) async {
    if (isClosed) return;

    if (userLocation == null) {
      emit(HomeError(AppLocale.locationError));
      return;
    }

    final int requestId = ++_homeRequestId;

    emit(const HomeLoading());

    try {
      final preferences = await getUserPreferencesUseCase(currentUserId);

      if (isClosed || requestId != _homeRequestId) {
        return;
      }

      final interests =
          preferences?.interests ??
          [AppLocale.specialtyCoffee, AppLocale.studyPlaces];

      final isSelectionFromToday = _isToday(preferences?.outingReasonDate);
      final mood = isSelectionFromToday ? preferences?.selectedMood : null;
      final occasion =
          isSelectionFromToday ? preferences?.selectedOccasion : null;

      String location = '';

      try {
        final placemarks = await placemarkFromCoordinates(
          userLocation.latitude,
          userLocation.longitude,
        );

        if (isClosed || requestId != _homeRequestId) {
          return;
        }

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;

          final possibleNames = <String?>[
            place.subLocality,
            place.locality,
            place.subAdministrativeArea,
            place.administrativeArea,
          ];

          for (final value in possibleNames) {
            if (value != null && value.trim().isNotEmpty) {
              location = value.trim();
              break;
            }
          }
        }
      } catch (_) {
        location = '';
      }

      if (location.isEmpty) {
        location = 'current location';
      }

      // أهم جزء:
      // بنمرر الـ GPS نفسه للـ recommendation layer
      // وليس اسم المنطقة فقط.
      final cafes = await getRecommendationsUseCase(
        interests: interests,
        mood: mood,
        occasion: occasion,
        location: location,
        userLocation: userLocation,
      );

      if (isClosed || requestId != _homeRequestId) {
        return;
      }

      if (cafes.isEmpty) {
        emit(const HomeEmpty());
        return;
      }

      final selectedCategory = categoryFilter ?? AppLocale.all;

      final filtered = _filterCafes(cafes, selectedCategory);

      if (isClosed || requestId != _homeRequestId) {
        return;
      }

      emit(
        HomeLoaded(
          recommendations: cafes,
          filteredCafes: filtered,
          userInterests: interests,
          activeMoodOrOccasion: mood ?? occasion,
          selectedCategory: selectedCategory,
        ),
      );
    } catch (e) {
      if (isClosed || requestId != _homeRequestId) {
        return;
      }

      emit(HomeError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  List<CafeRecommendationEntity> _filterCafes(
    List<CafeRecommendationEntity> cafes,
    String category,
  ) {
    if (category == AppLocale.all || category == 'الكل' || category == 'All') {
      return cafes;
    }

    String normalize(String value) {
      return value.trim().toLowerCase();
    }

    bool containsAny(List<String> list, List<String> targets) {
      for (final item in list) {
        final normalizedItem = normalize(item);

        for (final target in targets) {
          final normalizedTarget = normalize(target);

          if (normalizedItem == normalizedTarget ||
              normalizedItem.contains(normalizedTarget) ||
              normalizedTarget.contains(normalizedItem)) {
            return true;
          }
        }
      }

      return false;
    }

    return cafes.where((cafe) {
      if (category == AppLocale.forWork ||
          category == 'للعمل' ||
          category == 'Work / Study') {
        return containsAny(cafe.interests, [
              'للعمل',
              'أماكن للمذاكرة',
              'مذاكرة',
              'study',
              'work',
              'workspace',
              'working',
            ]) ||
            containsAny(cafe.moods, [
              'جلسة هادئة',
              'هادئ',
              'هدوء',
              'quiet',
              'calm',
              'peaceful',
              'study',
              'work',
            ]) ||
            containsAny(cafe.occasions, ['للعمل', 'work', 'study']);
      }

      if (category == AppLocale.coffeeCategoryTag ||
          category == 'قهوة' ||
          category == 'Coffee') {
        return containsAny(cafe.interests, [
              'قهوة',
              'قهوة مختصة',
              'coffee',
              'specialty coffee',
            ]) ||
            containsAny(cafe.moods, ['قهوة', 'coffee']);
      }

      return false;
    }).toList();
  }

  void filterByCategory(String category) {
    if (isClosed) return;

    final currentState = state;

    if (currentState is! HomeLoaded) {
      return;
    }

    final filtered = List<CafeRecommendationEntity>.from(
      _filterCafes(currentState.recommendations, category),
    );

    filtered.shuffle();

    if (isClosed) return;

    emit(
      currentState.copyWith(
        filteredCafes: filtered,
        selectedCategory: category,
      ),
    );
  }

  void searchCafes(String query) {
    if (isClosed) return;

    final searchQuery = query.trim();

    _searchDebounce?.cancel();

    if (searchQuery.isEmpty) {
      _clearSearch();
      return;
    }

    if (searchQuery.length < 4) {
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 800), () async {
      if (isClosed) return;

      await _performSearch(searchQuery);
    });
  }

  Future<void> _performSearch(String query) async {
    if (isClosed) return;

    final currentState = state;

    if (currentState is! HomeLoaded) {
      return;
    }

    emit(
      currentState.copyWith(
        searchQuery: query,
        searchResults: const [],
        isSearching: true,
        searchError: null,
      ),
    );

    try {
      final results = await searchCafesUseCase(query);

      if (isClosed) return;

      final latestState = state;

      if (latestState is! HomeLoaded) {
        return;
      }

      emit(
        latestState.copyWith(
          searchQuery: query,
          searchResults: results,
          isSearching: false,
          searchError: null,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      final latestState = state;

      if (latestState is! HomeLoaded) {
        return;
      }

      String message = e.toString();

      if (message.contains('429')) {
        message = AppLocale.searchRateLimitExceeded;
      } else {
        message = message.replaceAll('Exception: ', '');
      }

      if (isClosed) return;

      emit(
        latestState.copyWith(
          searchQuery: query,
          searchResults: const [],
          isSearching: false,
          searchError: message,
        ),
      );
    }
  }

  void clearSearch() {
    if (isClosed) return;

    _searchDebounce?.cancel();

    _clearSearch();
  }

  void _clearSearch() {
    if (isClosed) return;

    final currentState = state;

    if (currentState is HomeLoaded) {
      emit(
        currentState.copyWith(
          searchQuery: '',
          searchResults: const [],
          isSearching: false,
          searchError: null,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();

    return super.close();
  }
}
