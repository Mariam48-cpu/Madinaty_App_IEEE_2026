import 'package:injectable/injectable.dart';
import '../entities/review_entity.dart';
import '../repositories/reviews_repository_interface.dart';

@injectable
class SubmitReviewUseCase {
  final ReviewsRepositoryInterface repository;

  const SubmitReviewUseCase({required this.repository});

  Future<void> call(ReviewEntity review) {
    return repository.submitReview(review);
  }
}
