import 'package:injectable/injectable.dart';

import '../entities/group_cafe_entity.dart';
import '../repositories/group_cafe_repository_interface.dart';

@injectable
class SubmitGroupPicksUseCase {
  final GroupCafeRepositoryInterface repository;

  SubmitGroupPicksUseCase(this.repository);

  Future<void> call({
    required String groupId,
    required String userId,
    required List<GroupCafePickEntity> picks,
  }) {
    return repository.submitPicks(
      groupId: groupId,
      userId: userId,
      picks: picks,
    );
  }
}