import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/favorite_item_entity.dart';

class FavoriteItemModel extends FavoriteItemEntity {
  const FavoriteItemModel({
    required super.id,
    required super.targetId,
    required super.targetType,
    required super.title,
    super.imageUrl,
    super.rating,
    super.price,
    super.address,
    super.tagText,
    super.latitude,
    super.longitude,
    super.cafeId,
    super.categoryId,
    super.createdAt,
  });

  factory FavoriteItemModel.fromEntity(FavoriteItemEntity entity) {
    return FavoriteItemModel(
      id: entity.id,
      targetId: entity.targetId,
      targetType: entity.targetType,
      title: entity.title,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      price: entity.price,
      address: entity.address,
      tagText: entity.tagText,
      latitude: entity.latitude,
      longitude: entity.longitude,
      cafeId: entity.cafeId,
      categoryId: entity.categoryId,
      createdAt: entity.createdAt,
    );
  }

  factory FavoriteItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return FavoriteItemModel.fromMap(data, doc.id);
  }

  factory FavoriteItemModel.fromMap(Map<String, dynamic> data, String id) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return null;
    }

    final targetTypeStr = data['targetType'] as String? ?? 'cafe';
    final targetType = FavoriteTargetType.fromString(targetTypeStr);

    return FavoriteItemModel(
      id: id,
      targetId: data['targetId'] as String? ?? '',
      targetType: targetType,
      title: data['title'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      rating: (data['rating'] as num?)?.toDouble(),
      price: (data['price'] as num?)?.toDouble(),
      address: data['address'] as String?,
      tagText: data['tagText'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      cafeId: data['cafeId'] as String?,
      categoryId: data['categoryId'] as String?,
      createdAt: parseDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'targetId': targetId,
      'targetType': targetType.value,
      'title': title,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (rating != null) 'rating': rating,
      if (price != null) 'price': price,
      if (address != null) 'address': address,
      if (tagText != null) 'tagText': tagText,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (cafeId != null) 'cafeId': cafeId,
      if (categoryId != null) 'categoryId': categoryId,
    };

    if (createdAt != null) {
      data['createdAt'] = Timestamp.fromDate(createdAt!);
    } else {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    return data;
  }
}
