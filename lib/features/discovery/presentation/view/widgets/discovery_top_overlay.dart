import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/Icon_Button.dart';

class DiscoveryTopOverlay extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNotificationTap;
  final LatLng? userLocation;
  final List<String> filters;
  final int selectedChipIndex;
  final VoidCallback onFilterTap;
  final ValueChanged<int> onChipSelected;
  final Future<String> Function(double latitude, double longitude)
  getLocationName;
  final ValueChanged<String> onSearch;

  const DiscoveryTopOverlay({
    super.key,
    required this.onBack,
    required this.onNotificationTap,
    required this.userLocation,
    required this.filters,
    required this.selectedChipIndex,
    required this.onFilterTap,
    required this.onChipSelected,
    required this.getLocationName,
    required this.onSearch,
  });

  @override
  State<DiscoveryTopOverlay> createState() => _DiscoveryTopOverlayState();
}

class _DiscoveryTopOverlayState extends State<DiscoveryTopOverlay> {
  final TextEditingController searchController = TextEditingController();

  Timer? debounce;

  void onSearchChanged(String query) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(query);
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 16,
      right: 16,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    if (widget.userLocation != null)
                      FutureBuilder<String>(
                        future: widget.getLocationName(
                          widget.userLocation!.latitude,
                          widget.userLocation!.longitude,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              AppLocale.determiningLocation.getString(context),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            );
                          }

                          return Text(
                            snapshot.data ??
                                AppLocale.myCurrentLocation.getString(context),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          );
                        },
                      )
                    else
                      Text(
                        AppLocale.myCurrentLocation.getString(context),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                  ],
                ),
              ),
              IconButtonWidget(
                icon: Icons.notifications_none_outlined,
                onTap: widget.onNotificationTap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: searchController,
            textAlign: TextAlign.start,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: AppLocale.discoverySearchHint.getString(context),
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              suffixIcon: GestureDetector(
                onTap: widget.onFilterTap,
                child: const Icon(
                  Icons.tune,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = widget.selectedChipIndex == index;
                return GestureDetector(
                  onTap: () => widget.onChipSelected(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      widget.filters[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}