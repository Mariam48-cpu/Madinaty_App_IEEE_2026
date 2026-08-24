import 'package:injectable/injectable.dart';
import '../entities/pre_order_entity.dart';
import '../repositories/pre_order_repository_interface.dart';

@injectable
class WatchUserPreOrdersUseCase {
  final PreOrderRepositoryInterface repository;

  const WatchUserPreOrdersUseCase({required this.repository});

  Stream<List<PreOrderEntity>> call(String userId) {
    return repository.watchUserPreOrders(userId);
  }
}
