import 'package:injectable/injectable.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/reviews_repository_interface.dart';
import '../data_sources/reviews_remote_data_source_interface.dart';
import '../models/review_model.dart';

@Injectable(as: ReviewsRepositoryInterface)
class ReviewsRepositoryImpl implements ReviewsRepositoryInterface {
  final ReviewsRemoteDataSourceInterface dataSource;

  const ReviewsRepositoryImpl({required this.dataSource});

  @override
  Future<List<ReviewEntity>> getReviews(String cafeId) {
    return dataSource.getReviews(cafeId);
  }

  @override
  Stream<List<ReviewEntity>> watchReviews(String cafeId) {
    return dataSource.watchReviews(cafeId);
  }

  @override
  Future<void> submitReview(ReviewEntity review) {
    final model = ReviewModel.fromEntity(review);
    return dataSource.submitReview(model);
  }

  @override
  Future<ReviewEntity?> getUserReview({
    required String cafeId,
    required String userId,
  }) {
    return dataSource.getUserReview(cafeId: cafeId, userId: userId);
  }

  @override
  Future<void> deleteReview({
    required String cafeId,
    required String reviewId,
  }) {
    return dataSource.deleteReview(cafeId: cafeId, reviewId: reviewId);
  }
}
