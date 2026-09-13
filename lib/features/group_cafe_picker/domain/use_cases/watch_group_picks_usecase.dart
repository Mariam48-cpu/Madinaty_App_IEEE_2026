import 'package:injectable/injectable.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/entities/group_cafe_entity.dart';
import 'package:madinaty_app_ieee_2026/features/group_cafe_picker/domain/repositories/group_cafe_repository_interface.dart';

@injectable
class WatchGroupPicksUseCase {
  final GroupCafeRepositoryInterface repository;

  WatchGroupPicksUseCase(this.repository);

  Stream<Map<String, List<GroupCafePickEntity>>> call(String groupId) {
    return repository.watchPicks(groupId);
  }
}
