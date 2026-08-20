import 'package:injectable/injectable.dart';
import '../entities/cafe_recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

@injectable
class GetRecommendationsUseCase {
  final RecommendationRepository repository;

  GetRecommendationsUseCase(this.repository);

  Future<List<CafeRecommendationEntity>> call({
    required List<String> interests,
    required String? mood,
    required String? occasion,
    required String location,
  }) {
    return repository.getPersonalizedRecommendations(
      interests: interests,
      mood: mood,
      occasion: occasion,
      location: location,
    );
  }
}