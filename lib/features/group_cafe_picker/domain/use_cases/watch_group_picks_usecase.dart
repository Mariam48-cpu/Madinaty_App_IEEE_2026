import 'package:injectable/injectable.dart';

import '../entities/group_cafe_entity.dart';
import '../repositories/group_cafe_repository_interface.dart';

@injectable
class WatchGroupPicksUseCase {
  final GroupCafeRepositoryInterface repository;

  WatchGroupPicksUseCase(this.repository);

  Stream<Map<String, List<GroupCafePickEntity>>> call(
    String groupId,
  ) {
    return repository.watchPicks(groupId);
  }
}