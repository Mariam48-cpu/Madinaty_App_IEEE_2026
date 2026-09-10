import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/group_cafe_entity.dart';

class GroupMemberModel extends GroupMemberEntity {
  const GroupMemberModel({
    required super.userId,
    required super.name,
    super.imageUrl,
    super.isReady,
  });

  factory GroupMemberModel.fromEntity(
    GroupMemberEntity entity,
  ) {
    return GroupMemberModel(
      userId: entity.userId,
      name: entity.name,
      imageUrl: entity.imageUrl,
      isReady: entity.isReady,
    );
  }

  factory GroupMemberModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return GroupMemberModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? 'User',
      imageUrl: map['imageUrl'],
      isReady: map['isReady'] ?? false,
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

class GroupCafePickModel extends GroupCafePickEntity {
  const GroupCafePickModel({
    required super.cafeId,
    required super.cafeName,
    super.imageUrl,
    super.rating,
    super.address,
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
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      address: map['address'] ?? '',
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

class GroupCafeModel extends GroupCafeEntity {
  const GroupCafeModel({
    super.id,
    required super.name,
    required super.inviteCode,
    required super.creatorId,
    super.members,
    super.status,
    super.winnerCafeId,
    super.createdAt,
  });

  factory GroupCafeModel.fromEntity(
    GroupCafeEntity entity,
  ) {
    return GroupCafeModel(
      id: entity.id,
      name: entity.name,
      inviteCode: entity.inviteCode,
      creatorId: entity.creatorId,
      members: entity.members,
      status: entity.status,
      winnerCafeId: entity.winnerCafeId,
      createdAt: entity.createdAt,
    );
  }

  factory GroupCafeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    final membersData =
        List<Map<String, dynamic>>.from(data['members'] ?? []);

    return GroupCafeModel(
      id: doc.id,
      name: data['name'] ?? '',
      inviteCode: data['inviteCode'] ?? '',
      creatorId: data['creatorId'] ?? '',
      members: membersData
          .map(GroupMemberModel.fromMap)
          .toList(),
      status: GroupCafeStatus.values.firstWhere(
        (element) => element.name == data['status'],
        orElse: () => GroupCafeStatus.picking,
      ),
      winnerCafeId: data['winnerCafeId'],
      createdAt: _parseDate(data['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'inviteCode': inviteCode,
      'creatorId': creatorId,
      'members': members
          .map(
            (member) =>
                GroupMemberModel.fromEntity(member).toMap(),
          )
          .toList(),
      'status': status.name,
      'winnerCafeId': winnerCafeId,
      'createdAt': Timestamp.fromDate(
        createdAt ?? DateTime.now(),
      ),
    };
  }
}