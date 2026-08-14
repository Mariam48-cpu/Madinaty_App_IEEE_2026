import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/Icon_Button.dart';

class DiscoveryTopOverlay extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNotificationTap;
  final LatLng? userLocation;
  final List<String> filters;
  final int selectedChipIndex;
  final VoidCallback onFilterTap;
  final ValueChanged<int> onChipSelected;
  final Future<String> Function(double latitude, double longitude)
  getLocationName;

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
  });

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
              IconButtonWidget(icon: Icons.arrow_forward_ios, onTap: onBack),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),

                    if (userLocation != null)
                      FutureBuilder<String>(
                        future: getLocationName(
                          userLocation!.latitude,
                          userLocation!.longitude,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'جاري التحديد..',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          }

                          return Text(
                            snapshot.data ?? 'موقعي الحالي',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      )
                    else
                      const Text(
                        'موقعي الحالي',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),

              // Notification Button
              IconButtonWidget(
                icon: Icons.notifications_none_outlined,
                onTap: onNotificationTap,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن كافيه، منطقة',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,

                prefixIcon: const Icon(Icons.search, color: Colors.grey),

                suffixIcon: GestureDetector(
                  onTap: onFilterTap,
                  child: const Icon(Icons.tune, color: Colors.grey),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Filter Chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = selectedChipIndex == index;

                return GestureDetector(
                  onTap: () => onChipSelected(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5D4037)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 2),
                      ],
                    ),
                    child: Text(
                      filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
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
