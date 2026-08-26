import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import '../../domain/entities/cafe_recommendation_entity.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeEmpty extends HomeState {
  const HomeEmpty();
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}

class HomeLoaded extends HomeState {
  final List<CafeRecommendationEntity> recommendations;
  final List<CafeRecommendationEntity> filteredCafes;
  final List<String> userInterests;
  final String? activeMoodOrOccasion;
  final String selectedCategory;
  final String searchQuery;
  final List<CafeRecommendationEntity> searchResults;
  final bool isSearching;
  final String? searchError;

  const HomeLoaded({
    required this.recommendations,
    required this.filteredCafes,
    required this.userInterests,
    this.activeMoodOrOccasion,
    this.selectedCategory = AppLocale.all,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearching = false,
    this.searchError,
  });

  bool get isSearchActive {
    return searchQuery.trim().isNotEmpty;
  }

  HomeLoaded copyWith({
    List<CafeRecommendationEntity>? recommendations,
    List<CafeRecommendationEntity>? filteredCafes,
    List<String>? userInterests,
    String? activeMoodOrOccasion,
    String? selectedCategory,
    String? searchQuery,
    List<CafeRecommendationEntity>? searchResults,
    bool? isSearching,
    String? searchError,
    bool clearSearchError = false,
  }) {
    return HomeLoaded(
      recommendations: recommendations ?? this.recommendations,
      filteredCafes: filteredCafes ?? this.filteredCafes,
      userInterests: userInterests ?? this.userInterests,
      activeMoodOrOccasion: activeMoodOrOccasion ?? this.activeMoodOrOccasion,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchError: clearSearchError ? null : searchError ?? this.searchError,
    );
  }
}
