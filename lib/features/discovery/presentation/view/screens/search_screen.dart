import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

void _onSearchChanged(String value) {
  _debounce?.cancel();
  final query = value.trim();

  if (query.isEmpty) {
    widget.cubit.resetSearch(); // 👈 ارجع للـ Initial State لما السيرش يمسح
    return;
  }

  _debounce = Timer(const Duration(milliseconds: 500), () {
    widget.cubit.searchCafes(query: query);
  });
}

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Search Cafes')),
        body: Column(
          
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                  _onSearchChanged(value);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search by cafe name or area',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
                builder: (context, state) {
                  if (state is DiscoveryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DiscoveryError) {
                    return Center(
                      child: Text(state.message, textAlign: TextAlign.center),
                    );
                  }

                  if (state is DiscoveryEmpty) {
                    return const Center(child: Text('No cafes found.'));
                  }

                  if (state is DiscoverySuccess) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.cafes.length,
                      itemBuilder: (context, index) {
                        final cafe = state.cafes[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(cafe.name),
                            subtitle: Text(cafe.address),
                            trailing: cafe.rating > 0
                                ? Text('⭐ ${cafe.rating}')
                                : null,
                          ),
                        );
                      },
                    );
                  }

                  return const Center(child: Text('Search for a cafe or area'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
