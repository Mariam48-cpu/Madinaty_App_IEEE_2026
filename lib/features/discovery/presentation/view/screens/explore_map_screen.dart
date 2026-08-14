import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

class ExploreMapScreen extends StatelessWidget {
  final DiscoveryCubit cubit;

  const ExploreMapScreen({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit..loadNearbyCafes(),
      child: const _ExploreMapView(),
    );
  }
}

class _ExploreMapView extends StatefulWidget {
  const _ExploreMapView();

  @override
  State<_ExploreMapView> createState() => _ExploreMapViewState();
}

class _ExploreMapViewState extends State<_ExploreMapView> {
  final MapController _mapController = MapController();
  int _selectedChipIndex = 0;

  final List<String> _filters = [
    'مفتوح الآن',
    'Wi-Fi',
    'هادئ للعمل',
    'قهوة مختصة',
  ];

  // 📍 دالة جلب اسم الموقع النصي باستخدام مكتبة Location باحترافية
  Future<String> _getLocationName(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&accept-language=ar',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'madinaty_app_ieee_2026'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'];

        if (address != null) {
          // استخراج الحي/القرية/المدينة/المحافظة بالترتيب
          String townOrCity =
              address['village'] ??
              address['town'] ??
              address['city'] ??
              address['suburb'] ??
              '';
          String state = address['state'] ?? address['governorate'] ?? '';

          if (townOrCity.isNotEmpty && state.isNotEmpty) {
            return '$state، $townOrCity';
          } else if (townOrCity.isNotEmpty) {
            return townOrCity;
          } else if (state.isNotEmpty) {
            return state;
          }
        }
      }
    } catch (e) {
      debugPrint("Reverse Geocoding Error: $e");
    }

    return 'موقعي الحالي';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<DiscoveryCubit, DiscoveryState>(
          listener: (context, state) {
            if (state is DiscoveryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is DiscoveryLoading || state is DiscoveryInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DiscoveryError) {
              return Center(child: Text(state.message));
            }

            if (state is DiscoveryEmpty) {
              return const Center(
                child: Text('لم يتم العثور على كافيهات قريبة.'),
              );
            }

            if (state is DiscoverySuccess) {
              final location =
                  state.currentLocation ?? const LatLng(30.0988, 31.6263);

              return Stack(
                children: [
                  // 1️⃣ الخريطة في الخلفية (FlutterMap / OpenStreetMap)
                  _buildMap(state, location),

                  // 2️⃣ شريط البحث واسم المكان والفرز
                  _buildTopOverlay(state),

                  // 3️⃣ كروت الكافيهات السفلية
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: _buildBottomCafeCards(state),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // 🗺️ بناء الخريطة
  Widget _buildMap(DiscoverySuccess state, LatLng userLocation) {
    final markers = state.cafes.map((cafe) {
      return Marker(
        point: LatLng(cafe.location.latitude, cafe.location.longitude),
        width: 45,
        height: 45,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: const Icon(Icons.coffee, color: Colors.white, size: 22),
        ),
      );
    }).toList();

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: userLocation, initialZoom: 14.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.madinaty_app_ieee_2026',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }

  // 🔍 البار العلوي مع جلب النص المباشر
  Widget _buildTopOverlay(DiscoverySuccess state) {
    final userLocation = state.currentLocation;

    return Positioned(
      top: 12,
      left: 16,
      right: 16,
      child: Column(
        children: [
          // Row للرجوع، اسم المكان، الإشعارات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconButton(Icons.arrow_forward_ios, () {
                Navigator.pop(context);
              }),

              // 📍 اسم المكان الظاهر فوق
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
                        future: _getLocationName(
                          userLocation.latitude,
                          userLocation.longitude,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'جاري التحديد...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          }
                          return Text(
                            snapshot.data ?? 'القاهرة، مدينتي',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      )
                    else
                      const Text(
                        'القاهرة، مدينتي',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),

              _buildIconButton(Icons.notifications_none_outlined, () {}),
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
            child: const TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن كافيه، منطقه...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: Icon(Icons.tune, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Horizontal Filter Chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = _selectedChipIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedChipIndex = index),
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
                      _filters[index],
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

  // 💳 كروت الكافيهات السفلية
  Widget _buildBottomCafeCards(DiscoverySuccess state) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: state.cafes.length,
        itemBuilder: (context, index) {
          final cafe = state.cafes[index];
          return Container(
            width: 260,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // صورة الكافيه + التقييم
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: cafe.photos.isNotEmpty
                          ? Image.network(
                              cafe.photos.first,
                              height: 95,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 95,
                                      color: Colors.brown.shade50,
                                      child: const Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 95,
                                  width: double.infinity,
                                  color: Colors.brown.shade100,
                                  child: const Icon(
                                    Icons.storefront,
                                    size: 45,
                                    color: Colors.brown,
                                  ),
                                );
                              },
                            )
                          : Container(
                              height: 95,
                              width: double.infinity,
                              color: Colors.brown.shade100,
                              child: const Icon(
                                Icons.storefront,
                                size: 45,
                                color: Colors.brown,
                              ),
                            ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${cafe.rating}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // تفاصيل الكافيه
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.bookmark_border,
                              size: 20,
                              color: Colors.black54,
                            ),
                            Expanded(
                              child: Text(
                                cafe.name,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Text(
                          'قهوة مختصة • ${cafe.address}',
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'هادئ',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'سريع',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}
