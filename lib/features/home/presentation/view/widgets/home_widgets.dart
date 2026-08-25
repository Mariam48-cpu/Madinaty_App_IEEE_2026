import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import '../../view_model/home_cubit.dart';
import '../../view_model/home_state.dart';
import '../../../../favorites/domain/entities/favorite_item_entity.dart';
import '../../../../favorites/presentation/view_model/cubit/favorites_cubit.dart';
import '../../../../favorites/presentation/view_model/cubit/favorites_state.dart';

class MoodCard extends StatelessWidget {
  final HomeLoaded state;

  const MoodCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${AppLocale.yourMoodPrefix.getString(context)}: ${state.activeMoodOrOccasion}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  AppLocale.waitingCafeConfirmationSub.getString(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class HomeFilters extends StatelessWidget {
  const HomeFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = [
      AppLocale.all.getString(context),
      AppLocale.forWork.getString(context),
      AppLocale.coffeeCategoryTag.getString(context),
    ];

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoaded) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = state.selectedCategory == filter;

              return GestureDetector(
                onTap: () {
                  context.read<HomeCubit>().filterByCategory(filter);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.surfaceVariant : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CafeCard extends StatelessWidget {
  final dynamic cafe;

  const CafeCard({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = cafe.imageUrl.toString().trim();

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      buildWhen: (previous, current) {
        if (previous is FavoritesLoaded && current is FavoritesLoaded) {
          return previous.favoriteIds != current.favoriteIds;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, favoriteState) {
        bool isFavorite = false;

        if (favoriteState is FavoritesLoaded) {
          isFavorite = favoriteState.favoriteIds.contains(
            FavoriteItemEntity.generateId(
              FavoriteTargetType.cafe,
              cafe.id.toString(),
            ),
          );
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 175,
                    width: double.infinity,
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const CafeImagePlaceholder();
                      },
                    )
                        : const CafeImagePlaceholder(),
                  ),
                  PositionedDirectional(
                    top: 10,
                    start: 10,
                    child: GestureDetector(
                      onTap: () async {
                        final favoriteItem = FavoriteItemEntity(
                          id: FavoriteItemEntity.generateId(
                            FavoriteTargetType.cafe,
                            cafe.id.toString(),
                          ),
                          targetId: cafe.id.toString(),
                          targetType: FavoriteTargetType.cafe,
                          title: cafe.name.toString(),
                          imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                          rating: cafe.rating > 0 ? cafe.rating : null,
                          address: cafe.location?.toString(),
                          tagText: cafe.interests.isNotEmpty
                              ? cafe.interests.first
                              : null,
                          createdAt: DateTime.now(),
                        );

                        await context.read<FavoritesCubit>().toggleFavorite(
                          favoriteItem,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.94),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 20,
                          color: isFavorite ? AppColors.error : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            cafe.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            cafe.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '(${cafe.reviewsCount}) ⭐ ${cafe.rating.toStringAsFixed(1)}',
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${cafe.location} • ${cafe.distanceKm} ${AppLocale.distanceKm.getString(context)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cafe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SmallTag(icon: Icons.wifi_rounded, text: 'Wi-Fi'),
                        const SizedBox(width: 6),
                        SmallTag(
                          icon: Icons.groups_outlined,
                          text: AppLocale.suitableTag.getString(context),
                        ),
                        const SizedBox(width: 6),
                        SmallTag(
                          icon: Icons.coffee_rounded,
                          text: AppLocale.coffeeCategoryTag.getString(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CafeImagePlaceholder extends StatelessWidget {
  const CafeImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.local_cafe_rounded,
          size: 50,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class SmallTag extends StatelessWidget {
  final IconData icon;
  final String text;

  const SmallTag({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickCategories extends StatelessWidget {
  const QuickCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CategoryCard(
            title: AppLocale.specialtyCoffee.getString(context),
            subtitle: '12 ${AppLocale.placesCountText.getString(context)}',
            icon: Icons.coffee_rounded,
            backgroundColor: AppColors.surfaceVariant,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CategoryCard(
            title: AppLocale.studyPlaces.getString(context),
            subtitle: '8 ${AppLocale.placesCountText.getString(context)}',
            icon: Icons.menu_book_rounded,
            backgroundColor: AppColors.surfaceVariant,
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(icon, size: 19, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoFilteredResults extends StatelessWidget {
  const NoFilteredResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Icon(
            Icons.local_cafe_outlined,
            size: 45,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocale.noMatchingCafesFound.getString(context),
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final HomeError state;

  const ErrorStateWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 55,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocale.toastError.getString(context),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkButton,
                foregroundColor: AppColors.onDarkButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                context.read<HomeCubit>().fetchHomeData();
              },
              child: Text(AppLocale.retry.getString(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_cafe_outlined,
            size: 60,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            AppLocale.noMatchingCafesFound.getString(context),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkButton,
              foregroundColor: AppColors.onDarkButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.read<HomeCubit>().fetchHomeData();
            },
            child: Text(AppLocale.retry.getString(context)),
          ),
        ],
      ),
    );
  }
}

class SearchErrorWidget extends StatelessWidget {
  final String message;

  const SearchErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 45,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 10),
          Text(
            AppLocale.searchErrorOccurred.getString(context),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class NoSearchResults extends StatelessWidget {
  const NoSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 45,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 10),
          Text(
            AppLocale.noResultsFound.getString(context),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            AppLocale.trySearchingDifferentName.getString(context),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}