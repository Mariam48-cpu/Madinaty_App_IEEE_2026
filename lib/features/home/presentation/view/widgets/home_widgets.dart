import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/home_cubit.dart';
import '../../view_model/home_state.dart';

class MoodCard extends StatelessWidget {
  final HomeLoaded state;

  const MoodCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFEADBC9)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFE8D5BD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: Color(0xFF846646),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'مزاجك: ${state.activeMoodOrOccasion}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF55483D),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'بانتظار تأكيد الكافيه • رحل هادي',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Color(0xFF81766C)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_left_rounded, color: Color(0xFF806C59)),
        ],
      ),
    );
  }
}

class HomeFilters extends StatelessWidget {
  const HomeFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ['الكل', 'للعمل', 'قهوة'];

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
                    color: isSelected ? const Color(0xFFE9D7C2) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFE0C9AD)
                          : const Color(0xFFE9E2DA),
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: const Color(0xFF65594F),
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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9E1D8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                            color: const Color(0xFFF0ECE7),
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF8B6B4A),
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
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 19,
                    color: Color(0xFF685A4D),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.94),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: Color(0xFFB8884D),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        cafe.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C5046),
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
                          color: Color(0xFF403A35),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '(${cafe.reviewsCount}) ⭐ ${cafe.rating.toStringAsFixed(1)}',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF776D64),
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
                      color: Color(0xFF8B8178),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '${cafe.location} • ${cafe.distanceKm} كم',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF857B72),
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
                    color: Color(0xFF665C54),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    SmallTag(icon: Icons.wifi_rounded, text: 'Wi-Fi'),
                    SizedBox(width: 6),
                    SmallTag(icon: Icons.groups_outlined, text: 'مناسب'),
                    SizedBox(width: 6),
                    SmallTag(icon: Icons.coffee_rounded, text: 'قهوة'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CafeImagePlaceholder extends StatelessWidget {
  const CafeImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0ECE7),
      child: const Center(
        child: Icon(
          Icons.local_cafe_rounded,
          size: 50,
          color: Color(0xFFC9B9A7),
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
        color: const Color(0xFFF6F1EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF806C59)),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(fontSize: 9, color: Color(0xFF76695E)),
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
            title: 'قهوة مختصة',
            subtitle: '١٢ مكان',
            icon: Icons.coffee_rounded,
            backgroundColor: const Color(0xFFF3E9DC),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CategoryCard(
            title: 'أماكن للمذاكرة',
            subtitle: '٨ أماكن',
            icon: Icons.menu_book_rounded,
            backgroundColor: const Color(0xFFE8F1E9),
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
              color: Color(0xFF514840),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 15,
                  color: Color(0xFF826C58),
                ),
              ),
              Row(
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF7C7066),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(icon, size: 19, color: const Color(0xFFB09A84)),
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
      child: const Column(
        children: [
          Icon(Icons.local_cafe_outlined, size: 45, color: Color(0xFFC9B9A7)),
          SizedBox(height: 8),
          Text(
            'لا توجد مقاهي مناسبة',
            style: TextStyle(fontSize: 14, color: Color(0xFF756A61)),
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
              color: Color(0xFF9B7760),
            ),
            const SizedBox(height: 12),
            const Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF443D38),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF81766D)),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                context.read<HomeCubit>().fetchHomeData();
              },
              child: const Text('إعادة المحاولة'),
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
            color: Color(0xFFC9B9A7),
          ),
          const SizedBox(height: 12),
          const Text(
            'لا توجد نتائج مطابقة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              context.read<HomeCubit>().fetchHomeData();
            },
            child: const Text('إعادة المحاولة'),
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
            color: Color(0xFFC9B9A7),
          ),
          const SizedBox(height: 10),
          const Text(
            'حدث خطأ أثناء البحث',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF665C54),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Color(0xFF81766D)),
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
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 45, color: Color(0xFFC9B9A7)),
          SizedBox(height: 10),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF665C54),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'جرب البحث باسم كافيه أو منطقة أخرى',
            style: TextStyle(fontSize: 11, color: Color(0xFF81766D)),
          ),
        ],
      ),
    );
  }
}
