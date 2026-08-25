import 'package:injectable/injectable.dart';

import '../entities/ai_plan_entity.dart';
import '../repositories/ai_planner_repository.dart';

@injectable
class CreateAIPlan {
  final AIPlannerRepository repository;

  CreateAIPlan(this.repository);

  Future<AIPlanEntity> call(AIPlanRequestEntity request) {
    return repository.createPlan(request);
  }
}
