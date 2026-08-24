import 'package:injectable/injectable.dart';
import '../repositories/pre_order_repository_interface.dart';

@injectable
class CancelPreOrderUseCase {
  final PreOrderRepositoryInterface repository;

  const CancelPreOrderUseCase({required this.repository});

  Future<void> call(String preOrderId) {
    return repository.cancelPreOrder(preOrderId);
  }
}
