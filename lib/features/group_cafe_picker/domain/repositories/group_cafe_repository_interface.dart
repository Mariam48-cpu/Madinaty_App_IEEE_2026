import '../entities/group_cafe_entity.dart';

abstract class GroupCafeRepositoryInterface {
  Future<String> createGroup({
    required String groupName,
    required GroupMemberEntity creator,
  });

  Future<GroupCafeEntity> joinGroup({
    required String inviteCode,
    required GroupMemberEntity member,
  });

  Stream<GroupCafeEntity?> watchGroup(
    String groupId,
  );

  Future<void> submitPicks({
    required String groupId,
    required String userId,
    required List<GroupCafePickEntity> picks,
  });

  Stream<Map<String, List<GroupCafePickEntity>>> watchPicks(
    String groupId,
  );

  Future<void> markMemberReady({
    required String groupId,
    required String userId,
  });

  Future<void> spinGroup({
    required String groupId,
    required String winnerCafeId,
  });
}