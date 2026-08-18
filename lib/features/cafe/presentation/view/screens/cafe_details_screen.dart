import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_bottom_buttons.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_features.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_header.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_image.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_info_section.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_main_card.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_menu_section.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view_model/cubit/cafe_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view_model/cubit/cafe_state.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';

class CafeDetailsScreen extends StatefulWidget {
  final CafeEntity cafe;
  final LatLng? userLocation;

  const CafeDetailsScreen({super.key, required this.cafe, this.userLocation});

  @override
  State<CafeDetailsScreen> createState() => _CafeDetailsScreenState();
}

class _CafeDetailsScreenState extends State<CafeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CafeCubit>()..getCafeExperience(widget.cafe),
      child: Scaffold(
        backgroundColor: Color(0xFFFFF9F6),
        body: BlocBuilder<CafeCubit, CafeState>(
          builder: (context, state) {
            if (state is CafeLoading) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xFF8D6654)),
              );
            }

            if (state is CafeError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 55,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'حدث خطأ أثناء تحميل الكافيه',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CafeCubit>().getCafeExperience(
                            widget.cafe,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF17120F),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is CafeLoaded) {
              final experience = state.experience;
              final cafe = experience.cafe;
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                CafeImage(
                                  photos: cafe.photos,
                                  onFavorite: () {},
                                  onShare: () {},
                                  onBack: () => Navigator.pop(context),
                                ),

                                Transform.translate(
                                  offset: Offset(0, -60),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.08,
                                                ),
                                                blurRadius: 24,
                                                spreadRadius: 2,
                                                offset: Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: CafeMainCard(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                CafeHeader(
                                                  name: cafe.name,
                                                  rating: cafe.rating,
                                                  reviewsCount:
                                                      cafe.reviewsCount,
                                                ),
                                                SizedBox(height: 12),
                                                CafeInfoSection(cafe: cafe),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 24),
                                      if (cafe.description.isNotEmpty) ...[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'عن الكافيه',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2D2521),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                cafe.description,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  height: 1.6,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                      ],
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: CafeMenuSection(
                                          menu: experience.menu,
                                          onProductTap:
                                              (ProductEntity product) {},
                                          experience: experience,
                                        ),
                                      ),

                                      SizedBox(height: 24),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: CafeFeatures(
                                          attributes: cafe.attributes,
                                        ),
                                      ),

                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  CafeBottomButtons(onCall: () {}, onDirections: () {}),
                ],
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
