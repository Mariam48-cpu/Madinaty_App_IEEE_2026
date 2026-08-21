import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/search/search_bar.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/search/search_content.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/search/search_error_state.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

class SearchScreen extends StatefulWidget {
  final DiscoveryCubit cubit;

  const SearchScreen({super.key, required this.cubit});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> moods = ['العمل', 'جلسة هادئة', 'مع الأصحاب'];

  String currentQuery = '';

  int? selectedMoodIndex;

  final List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.cubit.loadNearbyCafes();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void search(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      clearSearch();
      return;
    }

    setState(() {
      currentQuery = query;

      if (!recentSearches.contains(query)) {
        recentSearches.insert(0, query);
      }
    });

    widget.cubit.searchCafes(query: query);
  }

  void clearSearch() {
    searchController.clear();

    setState(() {
      currentQuery = '';
      selectedMoodIndex = null;
    });

    widget.cubit.loadNearbyCafes();
  }

  void selectMood(int index) {
    final mood = moods[index];

    setState(() {
      selectedMoodIndex = index;
      currentQuery = mood;

      searchController.text = mood;

      searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchController.text.length),
      );

      if (!recentSearches.contains(mood)) {
        recentSearches.insert(0, mood);
      }
    });

    widget.cubit.searchCafes(query: mood);
  }

  void selectRecentSearch(String value) {
    searchController.text = value;

    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchController.text.length),
    );

    final moodIndex = moods.indexOf(value);

    setState(() {
      currentQuery = value;
      selectedMoodIndex = moodIndex == -1 ? null : moodIndex;
    });

    widget.cubit.searchCafes(query: value);
  }

  void removeRecentSearch(String value) {
    setState(() {
      recentSearches.remove(value);
    });
  }

  void clearRecentSearches() {
    setState(() {
      recentSearches.clear();
    });
  }

  void retrySearch() {
    if (currentQuery.isEmpty) {
      widget.cubit.loadNearbyCafes();
    } else {
      widget.cubit.searchCafes(query: currentQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        backgroundColor: Color(0xFFFFF9F6),
        body: SafeArea(
          child: Column(
            children: [
              SearchBarWidget(
                controller: searchController,
                onSearch: search,
                onClear: clearSearch,
                onBack: () => Navigator.pop(context),
                onChanged: () {
                  setState(() {});
                },
              ),

              SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
                  builder: (context, state) {
                    if (state is DiscoveryLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is DiscoveryError) {
                      return SearchErrorState(
                        message: state.message,
                        onRetry: retrySearch,
                      );
                    }

                    if (state is DiscoveryEmpty) {
                      return SearchContent(
                        cafes: [],
                        isEmpty: true,
                        currentQuery: currentQuery,
                        recentSearches: recentSearches,
                        moods: moods,
                        selectedMoodIndex: selectedMoodIndex,
                        onSearchSelected: selectRecentSearch,
                        onSearchRemoved: removeRecentSearch,
                        onClearRecentSearches: clearRecentSearches,
                        onMoodSelected: selectMood,
                        onShowNearby: clearSearch,
                      );
                    }

                    if (state is DiscoverySuccess) {
                      return SearchContent(
                        cafes: state.cafes,
                        isEmpty: false,
                        currentQuery: currentQuery,
                        recentSearches: recentSearches,
                        moods: moods,
                        selectedMoodIndex: selectedMoodIndex,
                        onSearchSelected: selectRecentSearch,
                        onSearchRemoved: removeRecentSearch,
                        onClearRecentSearches: clearRecentSearches,
                        onMoodSelected: selectMood,
                        onShowNearby: clearSearch,
                      );
                    }

                    return SearchContent(
                      cafes: [],
                      isEmpty: false,
                      currentQuery: currentQuery,
                      recentSearches: recentSearches,
                      moods: moods,
                      selectedMoodIndex: selectedMoodIndex,
                      onSearchSelected: selectRecentSearch,
                      onSearchRemoved: removeRecentSearch,
                      onClearRecentSearches: clearRecentSearches,
                      onMoodSelected: selectMood,
                      onShowNearby: clearSearch,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
