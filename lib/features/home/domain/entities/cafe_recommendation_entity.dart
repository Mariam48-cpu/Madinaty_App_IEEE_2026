class CafeRecommendationEntity {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final double distanceKm;
  final String location;
  final String description;
  final List<String> interests;
  final List<String> moods;
  final List<String> occasions;

  const CafeRecommendationEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.distanceKm,
    required this.location,
    required this.description,
    required this.interests,
    required this.moods,
    required this.occasions,
  });
}