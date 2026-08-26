import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_results_card.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

class CafeSearchDelegate extends SearchDelegate<String> {
  final DiscoveryCubit cubit;

  CafeSearchDelegate({required this.cubit});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear, color: AppColors.textSecondary),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return Center(
        child: Text(
          AppLocale.typeCafeNamePrompt.getString(context),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    cubit.searchCafes(query: query.trim());
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
        builder: (context, state) {
          if (state is DiscoveryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is DiscoveryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            );
          }
          if (state is DiscoveryEmpty ||
              (state is DiscoverySuccess && state.cafes.isEmpty)) {
            return Center(
              child: Text(
                AppLocale.noResultsFound.getString(context),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          if (state is DiscoverySuccess) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.cafes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return CategoryResultsCard(
                  cafe: state.cafes[index],
                  userLocation: state.currentLocation,
                  category: AppLocale.searchCategoryTitle.getString(context),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(
        AppLocale.searchForCafeNameHint.getString(context),
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}