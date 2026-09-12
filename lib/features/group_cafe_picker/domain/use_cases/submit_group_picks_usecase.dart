import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/repositories/group_cafe_repository_interface.dart';

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
