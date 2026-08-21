import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'recent_searches_section.dart';
import 'mood_section.dart';
import 'empty_search_state.dart';
import 'cafe_results_section.dart';
import 'drinks_section.dart';

class SearchContent extends StatelessWidget {
  final List<CafeEntity> cafes;
  final bool isEmpty;

  final String currentQuery;

  final List<String> recentSearches;
  final List<String> moods;
  final int? selectedMoodIndex;

  final ValueChanged<String> onSearchSelected;
  final ValueChanged<String> onSearchRemoved;
  final VoidCallback onClearRecentSearches;

  final ValueChanged<int> onMoodSelected;

  final VoidCallback onShowNearby;

  const SearchContent({
    super.key,
    required this.cafes,
    required this.isEmpty,
    required this.currentQuery,
    required this.recentSearches,
    required this.moods,
    required this.selectedMoodIndex,
    required this.onSearchSelected,
    required this.onSearchRemoved,
    required this.onClearRecentSearches,
    required this.onMoodSelected,
    required this.onShowNearby,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RecentSearchesSection(
            searches: recentSearches,
            onSearchSelected: onSearchSelected,
            onSearchRemoved: onSearchRemoved,
            onClearAll: onClearRecentSearches,
          ),

          SizedBox(height: 28),

          MoodSection(
            moods: moods,
            selectedIndex: selectedMoodIndex,
            onMoodSelected: onMoodSelected,
          ),

          SizedBox(height: 32),

          if (isEmpty)
            EmptySearchState(
              hasQuery: currentQuery.isNotEmpty,
              onShowNearby: onShowNearby,
            )
          else
            CafeResultsSection(cafes: cafes, query: currentQuery),

          SizedBox(height: 30),

          DrinksSection(),

          SizedBox(height: 30),
        ],
      ),
    );
  }
}
