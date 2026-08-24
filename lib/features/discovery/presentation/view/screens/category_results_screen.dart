import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_filter_chips.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_results_header.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/cafe_search_delegate.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_results_content.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';

class CategoryResultsScreen extends StatefulWidget {
  final DiscoveryCubit cubit;
  final String category;

  const CategoryResultsScreen({
    super.key,
    required this.cubit,
    required this.category,
  });

  @override
  State<CategoryResultsScreen> createState() => _CategoryResultsScreenState();
}

class _CategoryResultsScreenState extends State<CategoryResultsScreen> {
  int selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCategory();
    });
  }

  void loadCategory() {
    switch (widget.category) {
      case 'الكل':
        widget.cubit.showAllCafes();
        break;

      case 'مفتوح الآن':
        widget.cubit.getCafesByCategory(category: 'مفتوح الآن');
        break;

      case 'Wi-Fi':
        widget.cubit.getCafesByCategory(category: 'Wi-Fi');
        break;

      case 'هادئ للمذاكرة':
        widget.cubit.getCafesByCategory(category: 'هادئ للمذاكرة');
        break;

      case 'قهوة مختصة':
        widget.cubit.getCafesByCategory(category: 'قهوة مختصة');
        break;

      default:
        widget.cubit.getCafesByCategory(category: widget.category);
    }
  }

  String screenTitle() {
    switch (widget.category) {
      case 'هادئ للمذاكرة':
        return 'أماكن هادئة للمذاكرة';

      case 'مفتوح الآن':
        return 'أماكن مفتوحة الآن';

      case 'قهوة مختصة':
        return 'قهوة مختصة';

      case 'Wi-Fi':
        return 'أماكن بها Wi-Fi';

      case 'الكل':
        return 'كل الكافيهات';

      default:
        return widget.category;
    }
  }

  void openSearch() {
    showSearch(
      context: context,
      delegate: CafeSearchDelegate(cubit: widget.cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        backgroundColor: Color(0xFFF9F5F2),
        body: SafeArea(
          child: Column(
            children: [
              CategoryResultsHeader(
                title: screenTitle(),
                onBack: () => Navigator.pop(context),
                onSearch: openSearch,
              ),

              SizedBox(height: 8),

              CategoryFilterChips(
                selectedIndex: selectedFilterIndex,
                onSelected: (index) {
                  setState(() {
                    selectedFilterIndex = index;
                  });
                },
              ),

              SizedBox(height: 12),

              Expanded(
                child: CategoryResultsContent(
                  selectedFilterIndex: selectedFilterIndex,
                  selectedCategory: widget.category,
                  onRetry: loadCategory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
