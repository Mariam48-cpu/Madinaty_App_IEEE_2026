class ReviewEntity {
  final String id;
  final String cafeId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String text;
  final List<String> images;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.cafeId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.text,
    this.images = const [],
    required this.createdAt,
  });

  ReviewEntity copyWith({
    String? id,
    String? cafeId,
    String? userId,
    String? userName,
    String? userAvatar,
    double? rating,
    String? text,
    List<String>? images,
    DateTime? createdAt,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      cafeId: cafeId ?? this.cafeId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      text: text ?? this.text,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
