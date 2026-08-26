import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/skeletons/cafe_skeletons.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view/screens/book_table_screen.dart';
import 'package:madinaty_app_ieee_2026/features/booking/presentation/view_model/cubit/booking_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_bottom_buttons.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_features.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_header.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_image.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_info_section.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_main_card.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/widgets/cafe_details/cafe_menu_section.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view_model/cubit/cafe_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view_model/cubit/cafe_state.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/entities/favorite_item_entity.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/is_favorite_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/pre_order/presentation/view/screens/pre_order_screen.dart';
import 'package:madinaty_app_ieee_2026/features/reviews/presentation/view/screens/reviews_screen.dart';

class CafeDetailsScreen extends StatefulWidget {
  final CafeEntity cafe;
  final LatLng? userLocation;

  const CafeDetailsScreen({super.key, required this.cafe, this.userLocation});

  @override
  State<CafeDetailsScreen> createState() => _CafeDetailsScreenState();
}

class _CafeDetailsScreenState extends State<CafeDetailsScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final isFav = await sl<IsFavoriteUseCase>()(
      targetId: widget.cafe.id,
      type: FavoriteTargetType.cafe,
    );
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  Future<void> _toggleFavorite(CafeEntity cafe) async {
    final item = FavoriteItemEntity.fromCafe(cafe);
    await sl<ToggleFavoriteUseCase>()(item);
    if (mounted) {
      setState(() => _isFavorite = !_isFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CafeCubit>()..getCafeExperience(widget.cafe),
      child: Scaffold(
        backgroundColor: Color(0xFFFFF9F6),
        body: BlocBuilder<CafeCubit, CafeState>(
          builder: (context, state) {
            if (state is CafeLoading) {
              return CafeDetailsSkeleton();
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
                                SafeArea(
                                  child: CafeImage(
                                    photos: cafe.photos,
                                    isFavorite: _isFavorite,
                                    onFavorite: () => _toggleFavorite(cafe),
                                    onShare: () {},
                                    onBack: () => Navigator.pop(context),
                                  ),
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
                                                  onReviewsTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            ReviewsScreen(
                                                              cafeId: cafe.id,
                                                              cafeName:
                                                                  cafe.name,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(height: 12),
                                                CafeInfoSection(cafe: cafe),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 24),
                                      if (cafe.description.isNotEmpty) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'عن الكافيه',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2D2521),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
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
                                        const SizedBox(height: 24),
                                      ],
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: CafeMenuSection(
                                          menu: experience.menu,
                                          onProductTap:
                                              (ProductEntity product) {},
                                          experience: experience,
                                        ),
                                      ),

                                      const SizedBox(height: 24),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: CafeFeatures(
                                          attributes: cafe.attributes,
                                        ),
                                      ),

                                      const SizedBox(height: 24),
                                      // --- Reviews & Ratings Quick Access Card ---
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ReviewsScreen(
                                                  cafeId: cafe.id,
                                                  cafeName: cafe.name,
                                                ),
                                              ),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: const Color(0xFFF0E5DA),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.03),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.arrow_back_ios_new,
                                                  size: 14,
                                                  color: Color(0xFF8D6654),
                                                ),
                                                const Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      AppLocale
                                                          .reviewsAndRatings
                                                          .getString(context),
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xFF2D2521,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      '${cafe.rating.toStringAsFixed(1)} ★  (${cafe.reviewsCount} ${AppLocale.ratingsCountSuffix.getString(context)})',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color(
                                                          0xFF8A5A36,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 12),
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFFFF3EB,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.rate_review_outlined,
                                                    color: Color(0xFF8A5A36),
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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

                  CafeBottomButtons(
                    onCall: () {},
                    onDirections: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                sl<BookingCubit>()..setCafeId(cafe.id),
                            child: BookTableScreen(cafe: cafe),
                          ),
                        ),
                      );
                    },
                    onDirectionPreOrder: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                sl<BookingCubit>()..setCafeId(cafe.id),
                            child: PreOrderScreen(cafe: cafe),
                          ),
                        ),
                      );
                    },
                  ),
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
