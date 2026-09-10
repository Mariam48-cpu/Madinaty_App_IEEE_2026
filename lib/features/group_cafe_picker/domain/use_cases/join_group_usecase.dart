import 'package:injectable/injectable.dart';

import '../entities/group_cafe_entity.dart';
import '../repositories/group_cafe_repository_interface.dart';

@injectable
class JoinGroupUseCase {
  final GroupCafeRepositoryInterface repository;

  JoinGroupUseCase(this.repository);

  Future<GroupCafeEntity> call({
    required String inviteCode,
    required GroupMemberEntity member,
  }) {
    return repository.joinGroup(
      inviteCode: inviteCode,
      member: member,
    );
  }
}