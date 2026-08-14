import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSearchChanged(String query) {
    context.read<DiscoveryCubit>().searchCafes(query: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search cafes..',
            border: InputBorder.none,
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                      onSearchChanged('');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: BlocBuilder<DiscoveryCubit, DiscoveryState>(
        builder: (context, state) {
          if (state is DiscoveryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DiscoveryEmpty) {
            return const Center(child: Text('No cafes found'));
          }

          if (state is DiscoveryError) {
            return Center(child: Text(state.message));
          }

          if (state is DiscoverySuccess) {
            return ListView.builder(
              itemCount: state.cafes.length,
              itemBuilder: (context, index) {
                final cafe = state.cafes[index];
                return ListTile(
                  title: Text(cafe.name),
                  subtitle: Text(cafe.address),
                  trailing: cafe.rating > 0
                      ? Text(cafe.rating.toString())
                      : null,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
