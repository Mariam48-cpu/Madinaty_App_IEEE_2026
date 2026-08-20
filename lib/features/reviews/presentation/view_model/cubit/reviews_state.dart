import '../../../domain/entities/rating_breakdown_entity.dart';
import '../../../domain/entities/review_entity.dart';

enum ReviewFilterType {
  all,
  withPhotos,
  highestRating,
}

abstract class ReviewsState {
  const ReviewsState();
}

class ReviewsInitial extends ReviewsState {
  const ReviewsInitial();
}

class ReviewsLoading extends ReviewsState {
  const ReviewsLoading();
}

class ReviewsLoaded extends ReviewsState {
  final List<ReviewEntity> allReviews;
  final RatingBreakdownEntity breakdown;
  final ReviewFilterType selectedFilter;
  final ReviewEntity? userReview;
  final bool isSubmitting;
  final String? submitError;
  final bool submitSuccess;

  const ReviewsLoaded({
    required this.allReviews,
    required this.breakdown,
    this.selectedFilter = ReviewFilterType.all,
    this.userReview,
    this.isSubmitting = false,
    this.submitError,
    this.submitSuccess = false,
  });

  List<ReviewEntity> get filteredReviews {
    switch (selectedFilter) {
      case ReviewFilterType.all:
        return allReviews;
      case ReviewFilterType.withPhotos:
        return allReviews.where((r) => r.images.isNotEmpty).toList();
      case ReviewFilterType.highestRating:
        final sorted = List<ReviewEntity>.from(allReviews);
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        return sorted;
    }
  }

  int get withPhotosCount =>
      allReviews.where((r) => r.images.isNotEmpty).length;

  ReviewsLoaded copyWith({
    List<ReviewEntity>? allReviews,
    RatingBreakdownEntity? breakdown,
    ReviewFilterType? selectedFilter,
    ReviewEntity? userReview,
    bool clearUserReview = false,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    bool? submitSuccess,
  }) {
    return ReviewsLoaded(
      allReviews: allReviews ?? this.allReviews,
      breakdown: breakdown ?? this.breakdown,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      userReview: clearUserReview ? null : (userReview ?? this.userReview),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      submitSuccess: submitSuccess ?? false,
    );
  }
}

class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError({required this.message});
}
