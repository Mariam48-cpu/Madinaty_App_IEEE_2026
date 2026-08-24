import '../entities/ai_plan_entity.dart';

abstract class AIPlannerRepository {
  Future<AIPlanEntity> createPlan(AIPlanRequestEntity request);
}
