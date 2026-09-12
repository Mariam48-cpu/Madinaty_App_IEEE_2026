import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/repositories/group_cafe_repository_interface.dart';

@injectable
class JoinGroupUseCase {
  final GroupCafeRepositoryInterface repository;

  JoinGroupUseCase(this.repository);

  Future<GroupCafeEntity> call({
    required String inviteCode,
    required GroupMemberEntity member,
  }) {
    return repository.joinGroup(inviteCode: inviteCode, member: member);
  }
}
