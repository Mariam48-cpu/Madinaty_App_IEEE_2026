import '../entities/review_entity.dart';

abstract class ReviewsRepositoryInterface {
  /// Fetches reviews for a given cafe.
  Future<List<ReviewEntity>> getReviews(String cafeId);

  /// Streams real-time reviews for a given cafe.
  Stream<List<ReviewEntity>> watchReviews(String cafeId);

  /// Submits a new review or updates an existing review.
  Future<void> submitReview(ReviewEntity review);

  /// Gets the review submitted by a specific user for a cafe (if any).
  Future<ReviewEntity?> getUserReview({
    required String cafeId,
    required String userId,
  });

  /// Deletes a review by its ID.
  Future<void> deleteReview({
    required String cafeId,
    required String reviewId,
  });
}
