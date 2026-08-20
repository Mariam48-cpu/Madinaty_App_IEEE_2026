import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return Center(child: Text('اكتبي اسم الكافيه'));
    }
    cubit.searchCafes(query: query.trim());
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
        builder: (context, state) {
          if (state is DiscoveryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DiscoveryError) {
            return Center(child: Text(state.message));
          }
          if (state is DiscoveryEmpty ||
              (state is DiscoverySuccess && state.cafes.isEmpty)) {
            return Center(child: Text('لم يتم العثور على نتائج'));
          }
          if (state is DiscoverySuccess) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.cafes.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                return CategoryResultsCard(
                  cafe: state.cafes[index],
                  userLocation: state.currentLocation,
                  category: 'بحث',
                );
              },
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('ابحث عن اسم الكافيه', style: TextStyle(color: Colors.grey)),
    );
  }
}
