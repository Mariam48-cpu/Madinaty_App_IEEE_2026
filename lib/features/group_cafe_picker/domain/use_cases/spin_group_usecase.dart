import 'package:injectable/injectable.dart';

import '../repositories/group_cafe_repository_interface.dart';

@injectable
class SpinGroupUseCase {
  final GroupCafeRepositoryInterface repository;

  SpinGroupUseCase(this.repository);

  Future<void> call({required String groupId, required String winnerCafeId}) {
    return repository.spinGroup(groupId: groupId, winnerCafeId: winnerCafeId);
  }
}
