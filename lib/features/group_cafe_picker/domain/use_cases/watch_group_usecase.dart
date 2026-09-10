import 'package:injectable/injectable.dart';

import '../entities/group_cafe_entity.dart';
import '../repositories/group_cafe_repository_interface.dart';

@injectable
class WatchGroupUseCase {
  final GroupCafeRepositoryInterface repository;

  WatchGroupUseCase(this.repository);

  Stream<GroupCafeEntity?> call(
    String groupId,
  ) {
    return repository.watchGroup(groupId);
  }
}