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
        appBar: AppBar(title: Text(widget.category), centerTitle: true),
        body: BlocBuilder<DiscoveryCubit, DiscoveryState>(
          builder: (context, state) {
            if (state is DiscoveryLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is DiscoveryError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 56,
                        color: Colors.redAccent,
                      ),

                      SizedBox(height: 16),

                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          context.read<DiscoveryCubit>().getCafesByCategory(
                            category: widget.category,
                          );
                        },
                        child: Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is DiscoveryEmpty) {
              return Center(
                child: Text(
                  'No cafes found in this category',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (state is DiscoverySuccess) {
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: state.cafes.length,
                itemBuilder: (context, index) {
                  final cafe = state.cafes[index];

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      title: Text(
                        cafe.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          cafe.address,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),

                      trailing: cafe.rating > 0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    cafe.rating.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            )
                          : null,
                    ),
                  );
                },
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
