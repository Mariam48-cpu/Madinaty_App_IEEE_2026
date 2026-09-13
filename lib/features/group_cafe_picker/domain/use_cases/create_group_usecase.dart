import 'package:injectable/injectable.dart';

import '../entities/group_cafe_entity.dart';
import '../repositories/group_cafe_repository_interface.dart';

@injectable
class CreateGroupUseCase {
  final GroupCafeRepositoryInterface repository;

  CreateGroupUseCase(this.repository);

  Future<String> call({
    required String groupName,
    required GroupMemberEntity creator,
  }) {
    return repository.createGroup(
      groupName: groupName,
      creator: creator,
    );
  }
}