import 'review_entity.dart';

class RatingBreakdownEntity {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> starCounts;

  const RatingBreakdownEntity({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.starCounts = const {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
  });

  const RatingBreakdownEntity.empty()
      : averageRating = 0.0,
        totalReviews = 0,
        starCounts = const {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

  double getStarPercentage(int star) {
    if (totalReviews == 0) return 0.0;
    final count = starCounts[star] ?? 0;
    return count / totalReviews;
  }

  factory RatingBreakdownEntity.fromReviews(List<ReviewEntity> reviews) {
    if (reviews.isEmpty) {
      return const RatingBreakdownEntity.empty();
    }

    final counts = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    double totalScore = 0.0;

    for (final review in reviews) {
      totalScore += review.rating;
      final star = review.rating.round().clamp(1, 5);
      counts[star] = (counts[star] ?? 0) + 1;
    }

    final avg = totalScore / reviews.length;

    return RatingBreakdownEntity(
      averageRating: double.parse(avg.toStringAsFixed(1)),
      totalReviews: reviews.length,
      starCounts: counts,
    );
  }
}
