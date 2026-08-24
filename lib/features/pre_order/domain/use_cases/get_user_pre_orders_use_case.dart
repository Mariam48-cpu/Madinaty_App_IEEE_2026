import 'package:injectable/injectable.dart';
import '../entities/pre_order_entity.dart';
import '../repositories/pre_order_repository_interface.dart';

@injectable
class GetUserPreOrdersUseCase {
  final PreOrderRepositoryInterface repository;

  const GetUserPreOrdersUseCase({required this.repository});

  Future<List<PreOrderEntity>> call(String userId) {
    return repository.getUserPreOrders(userId);
  }
}
