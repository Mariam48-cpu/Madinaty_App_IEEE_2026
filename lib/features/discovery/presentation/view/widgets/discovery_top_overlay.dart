import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
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
    debounce = Timer(Duration(milliseconds: 500), () {
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
              IconButtonWidget(
                icon: Icons.arrow_forward_ios,
                onTap: widget.onBack,
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 4),

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
                              'جاري التحديد..',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          }

                          return Text(
                            snapshot.data ?? 'موقعي الحالي',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      )
                    else
                      Text(
                        'موقعي الحالي',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
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

          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: TextField(
              controller: searchController,
              textAlign: TextAlign.right,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ابحث عن كافيه، منطقة',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,

                prefixIcon: Icon(Icons.search, color: Colors.grey),

                suffixIcon: GestureDetector(
                  onTap: widget.onFilterTap,
                  child: Icon(Icons.tune, color: Colors.grey),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.filters.length,
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = widget.selectedChipIndex == index;
                return GestureDetector(
                  onTap: () => widget.onChipSelected(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF5D4037) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 2),
                      ],
                    ),
                    child: Text(
                      widget.filters[index],
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
