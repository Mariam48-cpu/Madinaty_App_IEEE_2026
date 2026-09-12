import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/data/models/group_cafe_model.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/data/models/group_cafe_pick_model.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/data/models/group_member_model.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/repositories/group_cafe_repository_interface.dart';

@LazySingleton(as: GroupCafeRepositoryInterface)
class GroupCafeRepositoryImpl implements GroupCafeRepositoryInterface {
  final FirebaseFirestore firestore;

  GroupCafeRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> groups() =>
      firestore.collection('cafe_groups');

  String generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final random = Random();

    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Future<String> createGroup({
    required String groupName,
    required GroupMemberEntity creator,
  }) async {
    final groupRef = groups().doc();

    final inviteCode = generateInviteCode();

    final creatorModel = GroupMemberModel.fromEntity(creator);

    final group = GroupCafeModel(
      id: groupRef.id,
      name: groupName,
      inviteCode: inviteCode,
      creatorId: creator.userId,
      members: [creatorModel],
      status: GroupCafeStatus.picking,
      createdAt: DateTime.now(),
    );

    await groupRef.set(group.toFirestore());

    return groupRef.id;
  }

  @override
  Future<GroupCafeEntity> joinGroup({
    required String inviteCode,
    required GroupMemberEntity member,
  }) async {
    final normalizedCode = inviteCode.trim().toUpperCase();

    final query = await groups()
        .where('inviteCode', isEqualTo: normalizedCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('Group not found');
    }

    final groupDoc = query.docs.first;

    final group = GroupCafeModel.fromFirestore(groupDoc);

    final alreadyJoined = group.members.any(
      (element) => element.userId == member.userId,
    );

    if (!alreadyJoined) {
      final memberModel = GroupMemberModel.fromEntity(member);

      final updatedMembers = [...group.members, memberModel];

      await groupDoc.reference.update({
        'members': updatedMembers.map((element) => element.toMap()).toList(),
      });
    }

    final updatedDoc = await groupDoc.reference.get();

    return GroupCafeModel.fromFirestore(updatedDoc).toEntity();
  }

  @override
  Stream<GroupCafeEntity?> watchGroup(String groupId) {
    return groups().doc(groupId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      return GroupCafeModel.fromFirestore(snapshot).toEntity();
    });
  }

  @override
  Future<void> submitPicks({
    required String groupId,
    required String userId,
    required List<GroupCafePickEntity> picks,
  }) async {
    final pickRef = groups().doc(groupId).collection('picks').doc(userId);

    final models = picks
        .map(GroupCafePickModel.fromEntity)
        .map((element) => element.toMap())
        .toList();

    await pickRef.set({
      'userId': userId,
      'cafes': models,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await markMemberReady(groupId: groupId, userId: userId);
  }

  @override
  Stream<Map<String, List<GroupCafePickEntity>>> watchPicks(String groupId) {
    return groups().doc(groupId).collection('picks').snapshots().map((
      snapshot,
    ) {
      final result = <String, List<GroupCafePickEntity>>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final rawCafes = data['cafes'];

        final cafes = rawCafes is List
            ? rawCafes
                  .whereType<Map>()
                  .map(
                    (cafe) => GroupCafePickModel.fromMap(
                      Map<String, dynamic>.from(cafe),
                    ),
                  )
                  .toList()
            : <GroupCafePickModel>[];

        result[doc.id] = cafes.map((cafe) => cafe.toEntity()).toList();
      }

      return result;
    });
  }

  @override
  Future<void> markMemberReady({
    required String groupId,
    required String userId,
  }) async {
    final groupRef = groups().doc(groupId);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(groupRef);

      if (!snapshot.exists) {
        throw Exception('Group not found');
      }

      final group = GroupCafeModel.fromFirestore(snapshot);

      final updatedMembers = group.members.map((member) {
        if (member.userId == userId) {
          return GroupMemberModel(
            userId: member.userId,
            name: member.name,
            imageUrl: member.imageUrl,
            isReady: true,
          );
        }

        return member;
      }).toList();

      final everyoneReady =
          updatedMembers.isNotEmpty &&
          updatedMembers.every((member) => member.isReady);

      transaction.update(groupRef, {
        'members': updatedMembers.map((member) => member.toMap()).toList(),
        'status': everyoneReady
            ? GroupCafeStatus.readyToSpin.name
            : GroupCafeStatus.picking.name,
      });
    });
  }

  @override
  Future<void> spinGroup({
    required String groupId,
    required String winnerCafeId,
  }) async {
    await groups().doc(groupId).update({
      'winnerCafeId': winnerCafeId,
      'status': GroupCafeStatus.completed.name,
    });
  }
}
