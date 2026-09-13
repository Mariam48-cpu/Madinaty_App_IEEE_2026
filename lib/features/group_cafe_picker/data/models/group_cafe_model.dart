import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'group_member_model.dart';

class GroupCafeModel {
  final String? id;
  final String name;
  final String inviteCode;
  final String creatorId;
  final List<GroupMemberModel> members;
  final GroupCafeStatus status;
  final String? winnerCafeId;
  final DateTime? createdAt;

  const GroupCafeModel({
    this.id,
    required this.name,
    required this.inviteCode,
    required this.creatorId,
    this.members = const [],
    this.status = GroupCafeStatus.picking,
    this.winnerCafeId,
    this.createdAt,
  });

  factory GroupCafeModel.fromEntity(
    GroupCafeEntity entity,
  ) {
    return GroupCafeModel(
      id: entity.id,
      name: entity.name,
      inviteCode: entity.inviteCode,
      creatorId: entity.creatorId,
      members: entity.members
          .map(GroupMemberModel.fromEntity)
          .toList(),
      status: entity.status,
      winnerCafeId: entity.winnerCafeId,
      createdAt: entity.createdAt,
    );
  }

  factory GroupCafeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    final rawMembers = data['members'];

    final members = rawMembers is List
        ? rawMembers
            .whereType<Map>()
            .map(
              (member) => GroupMemberModel.fromMap(
                Map<String, dynamic>.from(member),
              ),
            )
            .toList()
        : <GroupMemberModel>[];

    return GroupCafeModel(
      id: doc.id,
      name: data['name'] ?? '',
      inviteCode: data['inviteCode'] ?? '',
      creatorId: data['creatorId'] ?? '',
      members: members,
      status: GroupCafeStatus.values.firstWhere(
        (element) => element.name == data['status'],
        orElse: () => GroupCafeStatus.picking,
      ),
      winnerCafeId: data['winnerCafeId'],
      createdAt: parseDate(data['createdAt']),
    );
  }

  GroupCafeEntity toEntity() {
    return GroupCafeEntity(
      id: id ?? '',
      name: name,
      inviteCode: inviteCode,
      creatorId: creatorId,
      members: members
          .map((member) => member.toEntity())
          .toList(),
      status: status,
      winnerCafeId: winnerCafeId,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'inviteCode': inviteCode,
      'creatorId': creatorId,
      'members': members
          .map((member) => member.toMap())
          .toList(),
      'status': status.name,
      'winnerCafeId': winnerCafeId,
      'createdAt': Timestamp.fromDate(
        createdAt ?? DateTime.now(),
      ),
    };
  }

  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }
}