
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';

class GroupCafePickModel {
  final String cafeId;
  final String cafeName;
  final String? imageUrl;
  final double rating;
  final String address;

  const GroupCafePickModel({
    required this.cafeId,
    required this.cafeName,
    this.imageUrl,
    this.rating = 0,
    this.address = '',
  });

  factory GroupCafePickModel.fromEntity(
    GroupCafePickEntity entity,
  ) {
    return GroupCafePickModel(
      cafeId: entity.cafeId,
      cafeName: entity.cafeName,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      address: entity.address,
    );
  }

  factory GroupCafePickModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return GroupCafePickModel(
      cafeId: map['cafeId'] ?? '',
      cafeName: map['cafeName'] ?? '',
      imageUrl: map['imageUrl'],
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      address: map['address'] ?? '',
    );
  }

  GroupCafePickEntity toEntity() {
    return GroupCafePickEntity(
      cafeId: cafeId,
      cafeName: cafeName,
      imageUrl: imageUrl ?? '',
      rating: rating,
      address: address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cafeId': cafeId,
      'cafeName': cafeName,
      'imageUrl': imageUrl,
      'rating': rating,
      'address': address,
    };
  }
}