import 'package:equatable/equatable.dart';

enum GroupCafeStatus {
  picking,
  readyToSpin,
  completed,
}

class GroupMemberEntity extends Equatable {
  final String userId;
  final String name;
  final String? imageUrl;
  final bool isReady;

  const GroupMemberEntity({
    required this.userId,
    required this.name,
    this.imageUrl,
    this.isReady = false,
  });

  GroupMemberEntity copyWith({
    String? userId,
    String? name,
    String? imageUrl,
    bool? isReady,
  }) {
    return GroupMemberEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isReady: isReady ?? this.isReady,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        name,
        imageUrl,
        isReady,
      ];
}

class GroupCafePickEntity extends Equatable {
  final String cafeId;
  final String cafeName;
  final String imageUrl;
  final double rating;
  final String address;

  const GroupCafePickEntity({
    required this.cafeId,
    required this.cafeName,
    this.imageUrl = '',
    this.rating = 0,
    this.address = '',
  });

  @override
  List<Object?> get props => [
        cafeId,
        cafeName,
        imageUrl,
        rating,
        address,
      ];
}

class GroupCafeEntity extends Equatable {
  final String id;
  final String name;
  final String inviteCode;
  final String creatorId;
  final List<GroupMemberEntity> members;
  final GroupCafeStatus status;
  final String? winnerCafeId;
  final DateTime? createdAt;

  const GroupCafeEntity({
    this.id = '',
    required this.name,
    required this.inviteCode,
    required this.creatorId,
    this.members = const [],
    this.status = GroupCafeStatus.picking,
    this.winnerCafeId,
    this.createdAt,
  });

  GroupCafeEntity copyWith({
    String? id,
    String? name,
    String? inviteCode,
    String? creatorId,
    List<GroupMemberEntity>? members,
    GroupCafeStatus? status,
    String? winnerCafeId,
    DateTime? createdAt,
  }) {
    return GroupCafeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      creatorId: creatorId ?? this.creatorId,
      members: members ?? this.members,
      status: status ?? this.status,
      winnerCafeId: winnerCafeId ?? this.winnerCafeId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        inviteCode,
        creatorId,
        members,
        status,
        winnerCafeId,
        createdAt,
      ];
}