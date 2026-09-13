import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection_container.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/skeletons/reviews_skeleton.dart';
import 'package:toastification/toastification.dart';
import 'package:madinaty_app_ieee_2026/features/reviews/presentation/view_model/cubit/reviews_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/reviews/presentation/view_model/cubit/reviews_state.dart';
import '../widgets/category_rating_breakdown_card.dart';
import '../widgets/rating_summary_card.dart';
import '../widgets/review_card.dart';
import '../widgets/reviews_filter_row.dart';
import 'write_review_screen.dart';

class ReviewsScreen extends StatelessWidget {
  final String cafeId;
  final String cafeName;

  const ReviewsScreen({super.key, required this.cafeId, this.cafeName = ''});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReviewsCubit>()..initReviewsWatcher(cafeId),
      child: _ReviewsScreenContent(cafeId: cafeId, cafeName: cafeName),
    );
  }
}

class _ReviewsScreenContent extends StatelessWidget {
  final String cafeId;
  final String cafeName;

  const _ReviewsScreenContent({required this.cafeId, required this.cafeName});

  void _navigateToWriteReview(BuildContext context, ReviewsLoaded state) {
    final cubit = context.read<ReviewsCubit>();
    if (!cubit.isAuthenticated) {
      AppToast.showToast(
        context: context,
        title: AppLocale.toastError.getString(context),
        description: AppLocale.loginRequiredToReview.getString(context),
        type: ToastificationType.error,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WriteReviewScreen(
          cafeId: cafeId,
          cafeName: cafeName,
          existingReview: state.userReview,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReviewsCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom App Bar ---
            _buildAppBar(context),

            // --- Main Content ---
            Expanded(
              child: BlocBuilder<ReviewsCubit, ReviewsState>(
                builder: (context, state) {
                  if (state is ReviewsInitial || state is ReviewsLoading) {
                    return const ReviewsSkeleton();
                  }

                  if (state is ReviewsError) {
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
                              onPressed: () => cubit.loadReviews(cafeId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2D2521),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(AppLocale.retry.getString(context)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is ReviewsLoaded) {
                    final filteredReviews = state.filteredReviews;

                    return RefreshIndicator(
                      color: const Color(0xFF8D6654),
                      backgroundColor: Colors.white,
                      onRefresh: () => cubit.loadReviews(cafeId),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: Column(
                          children: [
                            // 1. Overall Rating Summary & Write Review CTA
                            RatingSummaryCard(
                              averageRating: state.breakdown.averageRating,
                              totalReviews: state.allReviews.length,
                              hasUserReviewed: state.userReview != null,
                              onWriteReviewPressed: () =>
                                  _navigateToWriteReview(context, state),
                            ),

                            const SizedBox(height: 20),

                            // 2. Real Star Distribution Breakdown Card (5★ down to 1★)
                            CategoryRatingBreakdownCard(
                              breakdown: state.breakdown,
                            ),

                            const SizedBox(height: 20),

                            // 3. Filter Chips Row (All, With Photos, Highest Rating)
                            ReviewsFilterRow(
                              selectedFilter: state.selectedFilter,
                              totalCount: state.allReviews.length,
                              withPhotosCount: state.withPhotosCount,
                              onFilterSelected: cubit.selectFilter,
                            ),

                            const SizedBox(height: 16),

                            // 4. Reviews List / Empty View
                            if (filteredReviews.isEmpty)
                              _buildEmptyState(context)
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredReviews.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return ReviewCard(
                                    review: filteredReviews[index],
                                  );
                                },
                              ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
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
          const SizedBox(width: 42),
          Text(
            AppLocale.reviewsAndRatings.getString(context),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2521),
            ),
          ),
          // Back button on right for RTL layout
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF2D2521),
                size: 22,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rate_review_outlined,
              size: 32,
              color: Color(0xFF8A5A36),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            AppLocale.noReviewsYet.getString(context),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2521),
            ),
          ),
        ],
      ),
    );
  }
}
