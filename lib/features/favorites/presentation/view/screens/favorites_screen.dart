import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/screens/cafe_details_screen.dart';
import 'package:madinaty_app_ieee_2026/features/cafe/presentation/view/screens/product_datails_screen.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/domain/entities/favorite_item_entity.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/presentation/view_model/cubit/favorites_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/favorites/presentation/view_model/cubit/favorites_state.dart';
 
 
import '../widgets/favorite_place_card.dart';
import '../widgets/favorite_product_card.dart';
import '../widgets/favorites_empty_view.dart';
import '../widgets/favorites_tab_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FavoritesCubit>()..initFavoritesWatcher(),
      child: const _FavoritesScreenContent(),
    );
  }
}

class _FavoritesScreenContent extends StatelessWidget {
  const _FavoritesScreenContent();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FavoritesCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      body: SafeArea(
        child: Column(
          children: [
            // --- Top App Bar ---
            _buildAppBar(context),

            // --- Tabs Section ---
            BlocBuilder<FavoritesCubit, FavoritesState>(
              buildWhen: (previous, current) =>
                  previous is! FavoritesLoaded ||
                  current is! FavoritesLoaded ||
                  (previous).selectedTab != (current).selectedTab,
              builder: (context, state) {
                final selectedTab = state is FavoritesLoaded
                    ? state.selectedTab
                    : FavoriteTargetType.cafe;

                return FavoritesTabBar(
                  selectedTab: selectedTab,
                  onTabSelected: cubit.selectTab,
                );
              },
            ),

            // --- Main Content List ---
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF8D6654),
                      ),
                    );
                  }

                  if (state is FavoritesError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              size: 48,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF7D726D),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: cubit.initFavoritesWatcher,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2D2521),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is FavoritesLoaded) {
                    final items = state.currentTabItems;

                    if (items.isEmpty) {
                      return const FavoritesEmptyView();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = items[index];

                        if (item.isCafe) {
                          return FavoritePlaceCard(
                            item: item,
                            onFavoriteToggle: () => cubit.toggleFavorite(item),
                            onTap: () => _navigateToCafeDetails(context, item),
                          );
                        } else {
                          return FavoriteProductCard(
                            item: item,
                            onFavoriteToggle: () => cubit.toggleFavorite(item),
                            onTap: () => _navigateToProductDetails(context, item),
                          );
                        }
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Notification Icon
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF2D2521),
                size: 22,
              ),
              onPressed: () {},
            ),
          ),

          // Title
          Text(
            AppLocale.navMyLists.getString(context),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2521),
            ),
          ),

          // Location Icon
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF2D2521),
                size: 22,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCafeDetails(BuildContext context, FavoriteItemEntity item) {
    final cafe = CafeEntity(
      id: item.targetId,
      name: item.title,
      location: LatLng(item.latitude ?? 0.0, item.longitude ?? 0.0),
      rating: item.rating ?? 0.0,
      photos: item.imageUrl != null && item.imageUrl!.isNotEmpty
          ? [item.imageUrl!]
          : const [],
      address: item.address ?? '',
      attributes: item.tagText != null && item.tagText!.isNotEmpty
          ? [item.tagText!]
          : const [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CafeDetailsScreen(cafe: cafe),
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context, FavoriteItemEntity item) {
    final product = ProductEntity(
      id: item.targetId,
      cafeId: item.cafeId ?? '',
      categoryId: item.categoryId ?? '',
      name: item.title,
      description: item.tagText ?? '',
      price: item.price ?? 0.0,
      image: item.imageUrl ?? '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(product: product),
      ),
    );
  }
}
