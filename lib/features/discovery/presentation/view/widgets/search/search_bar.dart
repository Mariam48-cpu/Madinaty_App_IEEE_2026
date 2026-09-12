import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final VoidCallback onBack;
  final VoidCallback onChanged;
  final ValueChanged<String> onSearch;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onBack,
    required this.onChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.start,
                textInputAction: TextInputAction.search,
                onSubmitted: onSearch,
                onChanged: (_) => onChanged(),
                decoration: InputDecoration(
                  hintText: AppLocale.searchBarHint.getString(context),
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.tune,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                    onPressed: onClear,
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  )
                      : IconButton(
                    onPressed: () {
                      onSearch(controller.text);
                    },
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}