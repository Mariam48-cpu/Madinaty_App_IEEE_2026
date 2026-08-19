import '../../domain/entities/onboarding_entity.dart';

class OnboardingModel extends OnboardingEntity {
  const OnboardingModel({
    required super.title,
    required super.description,
    required super.image,
  });

  factory OnboardingModel.fromEntity(OnboardingEntity entity) {
    return OnboardingModel(
      title: entity.title,
      description: entity.description,
      image: entity.image,
    );
  }
}