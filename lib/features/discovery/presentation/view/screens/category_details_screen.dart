import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String category;
  final DiscoveryCubit cubit;

  const CategoryDetailsScreen({
    super.key,
    required this.category,
    required this.cubit,
  });

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  @override
  void initState() {
    super.initState();

    widget.cubit.getCafesByCategory(category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.category)),
        body: BlocBuilder<DiscoveryCubit, DiscoveryState>(
          builder: (context, state) {
            if (state is DiscoveryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DiscoveryError) {
              return _buildErrorState(state.message);
            }

            if (state is DiscoveryEmpty) {
              return _buildEmptyState();
            }

            if (state is DiscoverySuccess) {
              return _buildCafeList(state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCafeList(DiscoverySuccess state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.cafes.length,
      itemBuilder: (context, index) {
        final cafe = state.cafes[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(cafe.name),
            subtitle: Text(cafe.address),
            trailing: cafe.rating > 0 ? Text('⭐ ${cafe.rating}') : null,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('No cafes found in this category.'));
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.cubit.getCafesByCategory(category: widget.category);
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
