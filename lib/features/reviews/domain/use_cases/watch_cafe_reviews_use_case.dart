import 'package:injectable/injectable.dart';
import '../entities/review_entity.dart';
import '../repositories/reviews_repository_interface.dart';

@injectable
class WatchCafeReviewsUseCase {
  final ReviewsRepositoryInterface repository;

  const WatchCafeReviewsUseCase({required this.repository});

  Stream<List<ReviewEntity>> call(String cafeId) {
    return repository.watchReviews(cafeId);
  }
}
