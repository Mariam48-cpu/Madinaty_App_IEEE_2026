import 'package:injectable/injectable.dart';
import '../entities/review_entity.dart';
import '../repositories/reviews_repository_interface.dart';

@injectable
class GetCafeReviewsUseCase {
  final ReviewsRepositoryInterface repository;

  const GetCafeReviewsUseCase({required this.repository});

  Future<List<ReviewEntity>> call(String cafeId) {
    return repository.getReviews(cafeId);
  }
}
