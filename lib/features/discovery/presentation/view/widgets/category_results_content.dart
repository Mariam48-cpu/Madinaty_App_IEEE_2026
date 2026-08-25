import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:toastification/toastification.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_results_card.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/discovery_empty_view.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/discovery_error_view.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

class CategoryResultsContent extends StatelessWidget {
  final int selectedFilterIndex;
  final String selectedCategory;
  final VoidCallback onRetry;

  const CategoryResultsContent({
    super.key,
    required this.selectedFilterIndex,
    required this.selectedCategory,
    required this.onRetry,
  });

  List<dynamic> getFilteredCafes(DiscoverySuccess state) {
    final cafes = List.of(state.cafes);

    if (selectedFilterIndex == 0) {
      cafes.sort((a, b) => b.rating.compareTo(a.rating));
      return cafes;
    }

    if (selectedFilterIndex == 1) {
      final LatLng? userLocation = state.currentLocation;
      if (userLocation == null) return cafes;

      const Distance distanceCalculator = Distance();
      cafes.sort((a, b) {
        final double distanceA = distanceCalculator.as(
          LengthUnit.Kilometer,
          userLocation,
          a.location,
        );
        final double distanceB = distanceCalculator.as(
          LengthUnit.Kilometer,
          userLocation,
          b.location,
        );
        return distanceA.compareTo(distanceB);
      });
      return cafes;
    }

    if (selectedFilterIndex == 2) {
      return cafes.where((cafe) => cafe.isOpen).toList();
    }

    return cafes;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiscoveryCubit, DiscoveryState>(
      listener: (context, state) {
        if (state is DiscoveryError) {
          AppToast.showToast(
            context: context,
            title: AppLocale.toastError.getString(context),
            description: state.message,
            type: ToastificationType.error,
          );
        }
      },
      builder: (context, state) {
        if (state is DiscoveryInitial || state is DiscoveryLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is DiscoveryError) {
          return DiscoveryErrorView(message: state.message, onRetry: onRetry);
        }

        if (state is DiscoveryEmpty) {
          return DiscoveryEmptyView(
            title: AppLocale.noNearbyCafesFound.getString(context),
            subtitle: AppLocale.tryAnotherCategorySubtitle.getString(context),
          );
        }

        if (state is DiscoverySuccess) {
          final cafes = getFilteredCafes(state);

          if (cafes.isEmpty) {
            final String emptyMsg = selectedFilterIndex == 2
                ? AppLocale.noOpenPlacesNow.getString(context)
                : selectedFilterIndex == 1
                ? AppLocale.noNearbyPlacesAvailable.getString(context)
                : AppLocale.noNearbyCafesFound.getString(context);

            return DiscoveryEmptyView(
              title: emptyMsg,
              subtitle: AppLocale.tryAnotherFilterSubtitle.getString(context),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: cafes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              return CategoryResultsCard(
                cafe: cafes[index],
                userLocation: state.currentLocation,
                category: selectedCategory,
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}