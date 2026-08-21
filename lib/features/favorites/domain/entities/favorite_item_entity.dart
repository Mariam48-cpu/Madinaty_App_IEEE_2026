import 'package:madinaty_app_ieee_2026/features/cafe/domain/entities/product_entity.dart';
import 'package:madinaty_app_ieee_2026/features/discovery/domain/entities/cafe_entity.dart';

enum FavoriteTargetType {
  cafe,
  product;

  String get value => name;

  static FavoriteTargetType fromString(String value) {
    return FavoriteTargetType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => FavoriteTargetType.cafe,
    );
  }
}

class FavoriteItemEntity {
  final String id;
  final String targetId;
  final FavoriteTargetType targetType;
  final String title;
  final String? imageUrl;
  final double? rating;
  final double? price;
  final String? address;
  final String? tagText;
  final double? latitude;
  final double? longitude;
  final String? cafeId;
  final String? categoryId;
  final DateTime? createdAt;

  const FavoriteItemEntity({
    required this.id,
    required this.targetId,
    required this.targetType,
    required this.title,
    this.imageUrl,
    this.rating,
    this.price,
    this.address,
    this.tagText,
    this.latitude,
    this.longitude,
    this.cafeId,
    this.categoryId,
    this.createdAt,
  });

  bool get isCafe => targetType == FavoriteTargetType.cafe;
  bool get isProduct => targetType == FavoriteTargetType.product;

  /// Canonical ID generator: `${targetType.name}_$targetId`
  static String generateId(FavoriteTargetType type, String targetId) =>
      '${type.name}_$targetId';

  factory FavoriteItemEntity.fromCafe(CafeEntity cafe) {
    return FavoriteItemEntity(
      id: generateId(FavoriteTargetType.cafe, cafe.id),
      targetId: cafe.id,
      targetType: FavoriteTargetType.cafe,
      title: cafe.name,
      imageUrl: cafe.photos.isNotEmpty ? cafe.photos.first : null,
      rating: cafe.rating > 0 ? cafe.rating : null,
      address: cafe.address.isNotEmpty ? cafe.address : null,
      tagText: cafe.attributes.isNotEmpty ? cafe.attributes.first : null,
      latitude: cafe.location.latitude,
      longitude: cafe.location.longitude,
      createdAt: DateTime.now(),
    );
  }

  factory FavoriteItemEntity.fromProduct(ProductEntity product) {
    return FavoriteItemEntity(
      id: generateId(FavoriteTargetType.product, product.id),
      targetId: product.id,
      targetType: FavoriteTargetType.product,
      title: product.name,
      imageUrl: product.image.isNotEmpty ? product.image : null,
      price: product.price,
      cafeId: product.cafeId,
      categoryId: product.categoryId,
      createdAt: DateTime.now(),
    );
  }

  FavoriteItemEntity copyWith({
    String? id,
    String? targetId,
    FavoriteTargetType? targetType,
    String? title,
    String? imageUrl,
    double? rating,
    double? price,
    String? address,
    String? tagText,
    double? latitude,
    double? longitude,
    String? cafeId,
    String? categoryId,
    DateTime? createdAt,
  }) {
    return FavoriteItemEntity(
      id: id ?? this.id,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      address: address ?? this.address,
      tagText: tagText ?? this.tagText,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cafeId: cafeId ?? this.cafeId,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
