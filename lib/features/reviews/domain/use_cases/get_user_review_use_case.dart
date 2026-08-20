import 'package:injectable/injectable.dart';
import '../entities/review_entity.dart';
import '../repositories/reviews_repository_interface.dart';

@injectable
class GetUserReviewUseCase {
  final ReviewsRepositoryInterface repository;

  const GetUserReviewUseCase({required this.repository});

  Future<ReviewEntity?> call({
    required String cafeId,
    required String userId,
  }) {
    return repository.getUserReview(
      cafeId: cafeId,
      userId: userId,
    );
  }
}
