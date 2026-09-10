import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/group_cafe_entity.dart';
import '../../domain/repositories/group_cafe_repository_interface.dart';
import '../models/group_cafe_model.dart';

@LazySingleton(as: GroupCafeRepositoryInterface)
class GroupCafeRepositoryImpl
    implements GroupCafeRepositoryInterface {
  final FirebaseFirestore firestore;

  GroupCafeRepositoryImpl({
    FirebaseFirestore? firestore,
  }) : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _groups =>
      firestore.collection('cafe_groups');

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final random = Random();

    return List.generate(
      6,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  @override
  Future<String> createGroup({
    required String groupName,
    required GroupMemberEntity creator,
  }) async {
    final groupRef = _groups.doc();

    final inviteCode = _generateInviteCode();

    final group = GroupCafeModel(
      id: groupRef.id,
      name: groupName,
      inviteCode: inviteCode,
      creatorId: creator.userId,
      members: [creator],
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
    final query = await _groups
        .where('inviteCode', isEqualTo: inviteCode.trim().toUpperCase())
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
      final updatedMembers = [
        ...group.members,
        member,
      ];

      await groupDoc.reference.update({
        'members': updatedMembers
            .map(
              (element) =>
                  GroupMemberModel.fromEntity(element).toMap(),
            )
            .toList(),
      });
    }

    final updatedDoc = await groupDoc.reference.get();

    return GroupCafeModel.fromFirestore(updatedDoc);
  }

  @override
  Stream<GroupCafeEntity?> watchGroup(
    String groupId,
  ) {
    return _groups.doc(groupId).snapshots().map(
      (snapshot) {
        if (!snapshot.exists) {
          return null;
        }

        return GroupCafeModel.fromFirestore(snapshot);
      },
    );
  }

  @override
  Future<void> submitPicks({
    required String groupId,
    required String userId,
    required List<GroupCafePickEntity> picks,
  }) async {
    final pickRef = _groups
        .doc(groupId)
        .collection('picks')
        .doc(userId);

    final models = picks
        .map(GroupCafePickModel.fromEntity)
        .map((element) => element.toMap())
        .toList();

    await pickRef.set({
      'userId': userId,
      'cafes': models,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await markMemberReady(
      groupId: groupId,
      userId: userId,
    );
  }

  @override
  Stream<Map<String, List<GroupCafePickEntity>>> watchPicks(
    String groupId,
  ) {
    return _groups
        .doc(groupId)
        .collection('picks')
        .snapshots()
        .map((snapshot) {
      final result = <String, List<GroupCafePickEntity>>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final cafes =
            List<Map<String, dynamic>>.from(data['cafes'] ?? []);

        result[doc.id] = cafes
            .map(GroupCafePickModel.fromMap)
            .toList();
      }

      return result;
    });
  }

  @override
  Future<void> markMemberReady({
    required String groupId,
    required String userId,
  }) async {
    final groupRef = _groups.doc(groupId);

    await firestore.runTransaction(
      (transaction) async {
        final snapshot = await transaction.get(groupRef);

        if (!snapshot.exists) {
          throw Exception('Group not found');
        }

        final group =
            GroupCafeModel.fromFirestore(snapshot);

        final updatedMembers = group.members.map(
          (member) {
            if (member.userId == userId) {
              return member.copyWith(isReady: true);
            }

            return member;
          },
        ).toList();

        final everyoneReady = updatedMembers.isNotEmpty &&
            updatedMembers.every(
              (member) => member.isReady,
            );

        transaction.update(
          groupRef,
          {
            'members': updatedMembers
                .map(
                  (member) =>
                      GroupMemberModel.fromEntity(member).toMap(),
                )
                .toList(),
            'status': everyoneReady
                ? GroupCafeStatus.readyToSpin.name
                : GroupCafeStatus.picking.name,
          },
        );
      },
    );
  }

  @override
  Future<void> spinGroup({
    required String groupId,
    required String winnerCafeId,
  }) async {
    await _groups.doc(groupId).update({
      'winnerCafeId': winnerCafeId,
      'status': GroupCafeStatus.completed.name,
    });
  }
}