import '../models/review_model.dart';

abstract class ReviewsRemoteDataSourceInterface {
  /// Fetches reviews for a cafe from Firestore.
  Future<List<ReviewModel>> getReviews(String cafeId);

  /// Streams real-time reviews for a cafe from Firestore.
  Stream<List<ReviewModel>> watchReviews(String cafeId);

  /// Submits or updates a review in Firestore.
  Future<void> submitReview(ReviewModel review);

  /// Gets the review submitted by a specific user for a cafe (if any).
  Future<ReviewModel?> getUserReview({
    required String cafeId,
    required String userId,
  });

  /// Deletes a review document by its ID.
  Future<void> deleteReview({
    required String cafeId,
    required String reviewId,
  });
}
