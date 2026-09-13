import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';

class GroupMemberModel {
  final String userId;
  final String name;
  final String? imageUrl;
  final bool isReady;

  const GroupMemberModel({
    required this.userId,
    required this.name,
    this.imageUrl,
    this.isReady = false,
  });

  factory GroupMemberModel.fromEntity(GroupMemberEntity entity) {
    return GroupMemberModel(
      userId: entity.userId,
      name: entity.name,
      imageUrl: entity.imageUrl,
      isReady: entity.isReady,
    );
  }

  factory GroupMemberModel.fromMap(Map<String, dynamic> map) {
    return GroupMemberModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? 'User',
      imageUrl: map['imageUrl'],
      isReady: map['isReady'] ?? false,
    );
  }

  GroupMemberEntity toEntity() {
    return GroupMemberEntity(
      userId: userId,
      name: name,
      imageUrl: imageUrl,
      isReady: isReady,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
      'isReady': isReady,
    };
  }
}
