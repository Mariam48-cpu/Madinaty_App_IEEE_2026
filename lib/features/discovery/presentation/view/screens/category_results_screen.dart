import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/cafe_search_delegate.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_filter_chips.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_results_content.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/category_results_header.dart';
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
        widget.cubit.loadNearbyCafes();
        break;
      case 'مفتوح الآن':
        widget.cubit.getCafesByCategory(category: 'cafes open now');
        break;
      case 'هادئ للمذاكرة':
        widget.cubit.getCafesByCategory(category: 'quiet cafes for studying');
        break;
      case 'قهوة مختصة':
        widget.cubit.getCafesByCategory(category: 'specialty coffee');
        break;
      default:
        widget.cubit.getCafesByCategory(category: widget.category);
    }
  }

  String screenTitle(BuildContext context) {
    switch (widget.category) {
      case 'هادئ للمذاكرة':
        return AppLocale.study.getString(context);
      case 'مفتوح الآن':
        return AppLocale.openNow.getString(context);
      case 'قهوة مختصة':
        return AppLocale.specialtyCoffee.getString(context);
      case 'الكل':
        return AppLocale.all.getString(context);
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
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              CategoryResultsHeader(
                title: screenTitle(context),
                onBack: () => Navigator.pop(context),
                onSearch: openSearch,
              ),
              const SizedBox(height: 8),
              CategoryFilterChips(
                selectedIndex: selectedFilterIndex,
                onSelected: (index) =>
                    setState(() => selectedFilterIndex = index),
              ),
              const SizedBox(height: 12),
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