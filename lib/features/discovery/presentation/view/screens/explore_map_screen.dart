import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/screens/category_results_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/bottom_cafes_cards.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/discovery_map.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view/widgets/discovery_top_overlay.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/presentation/view_model/cubit/discovery_state.dart';

class ExploreMapScreen extends StatefulWidget {
  final DiscoveryCubit cubit;

  const ExploreMapScreen({super.key, required this.cubit});

  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  final MapController mapController = MapController();

  int selectedChipIndex = 0;
  String? cachedLocationName;
  LatLng? lastGeocodedLocation;

  final List<String> filters = [
    'مفتوح الآن',
    'Wi-Fi',
    'هادئ للمذاكرة',
    'قهوة مختصة',
  ];

  void onFilterTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CategoryResultsScreen(cubit: widget.cubit, category: 'الكل'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.cubit.currentLocation == null) {
      widget.cubit.loadNearbyCafes();
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    if (lastGeocodedLocation != null &&
        (lastGeocodedLocation!.latitude != latitude ||
            lastGeocodedLocation!.longitude != longitude)) {
      cachedLocationName = null;
    }

    if (lastGeocodedLocation != null &&
        lastGeocodedLocation!.latitude == latitude &&
        lastGeocodedLocation!.longitude == longitude &&
        cachedLocationName != null) {
      return cachedLocationName!;
    }

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=json'
        '&lat=$latitude'
        '&lon=$longitude'
        '&accept-language=ar',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'madinaty_app_ieee_2026'},
      );

      if (!mounted) return cachedLocationName ?? 'جاري تحديد الموقع...';

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'];

        if (address != null) {
          final String townOrCity =
              address['village'] ??
              address['town'] ??
              address['city'] ??
              address['suburb'] ??
              '';
          final String state = address['state'] ?? address['governorate'] ?? '';

          String resultName = 'موقعي الحالي';
          if (townOrCity.isNotEmpty && state.isNotEmpty) {
            resultName = '$state، $townOrCity';
          } else if (townOrCity.isNotEmpty) {
            resultName = townOrCity;
          } else if (state.isNotEmpty) {
            resultName = state;
          }

          cachedLocationName = resultName;
          lastGeocodedLocation = LatLng(latitude, longitude);
          return resultName;
        }
      }
    } catch (e) {
      debugPrint('Reverse Geocoding Error: $e');
    }

    return cachedLocationName ?? 'موقعي الحالي';
  }

  void onChipSelected(int index) {
    setState(() {
      selectedChipIndex = index;
    });

    String category;

    switch (index) {
      case 0:
        category = 'مفتوح الآن';
        break;

      case 1:
        category = 'Wi-Fi';
        break;

      case 2:
        category = 'هادئ للمذاكرة';
        break;

      case 3:
        category = 'قهوة مختصة';
        break;

      default:
        category = 'الكل';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CategoryResultsScreen(cubit: widget.cubit, category: category),
      ),
    );
  }

  void onSearch(String query) {
    widget.cubit.searchCafes(query: query);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              BlocConsumer<DiscoveryCubit, DiscoveryState>(
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
                  if (state is DiscoveryInitial || state is DiscoveryLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is DiscoveryError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is DiscoveryEmpty) {
                    return Center(
                      child: Text('لم يتم العثور على كافيهات قريبة.'),
                    );
                  }
                  if (state is DiscoverySuccess) {
                    final location =
                        state.currentLocation ?? LatLng(30.0988, 31.6263);
                    return Stack(
                      children: [
                        DiscoveryMapWidget(
                          mapController: mapController,
                          location: location,
                          cafes: state.cafes,
                          userLocation: location,
                        ),
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: BottomCafesCards(
                            cafeList: state.cafes,
                            state: state,
                          ),
                        ),
                      ],
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
              BlocBuilder<DiscoveryCubit, DiscoveryState>(
                buildWhen: (previous, current) {
                  if (previous is DiscoverySuccess &&
                      current is DiscoverySuccess) {
                    return previous.currentLocation != current.currentLocation;
                  }
                  return true;
                },
                builder: (context, state) {
                  LatLng? location;
                  if (state is DiscoverySuccess) {
                    location = state.currentLocation;
                  } else {
                    location = widget.cubit.currentLocation;
                  }

                  return DiscoveryTopOverlay(
                    onBack: () => Navigator.pop(context),
                    onNotificationTap: () {},
                    userLocation: location,
                    filters: filters,
                    selectedChipIndex: selectedChipIndex,
                    onFilterTap: onFilterTap,
                    onChipSelected: onChipSelected,
                    getLocationName: getLocationName,
                    onSearch: onSearch,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
