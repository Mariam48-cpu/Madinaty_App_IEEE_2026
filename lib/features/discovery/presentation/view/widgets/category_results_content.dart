import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is DiscoveryInitial || state is DiscoveryLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is DiscoveryError) {
          return DiscoveryErrorView(message: state.message, onRetry: onRetry);
        }

        if (state is DiscoveryEmpty) {
          return DiscoveryEmptyView(
            title: 'لم يتم العثور على كافيهات',
            subtitle: 'جربي تصنيفًا آخر أو ابحثي عن كافيه مختلف.',
          );
        }

        if (state is DiscoverySuccess) {
          final cafes = getFilteredCafes(state);

          if (cafes.isEmpty) {
            final String emptyMsg = selectedFilterIndex == 2
                ? 'لا توجد أماكن مفتوحة الآن.'
                : selectedFilterIndex == 1
                ? 'لا توجد أماكن قريبة متاحة.'
                : 'لم يتم العثور على كافيهات.';

            return DiscoveryEmptyView(
              title: emptyMsg,
              subtitle: 'جربي اختيار فلتر آخر.',
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
