import 'package:injectable/injectable.dart';

import '../entities/cafe_recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

@injectable
class SearchCafesUseCase {
  final RecommendationRepository repository;

  SearchCafesUseCase(this.repository);

  Future<List<CafeRecommendationEntity>> call(
    String query,
  ) {
    return repository.searchCafes(query);
  }
}