import 'package:injectable/injectable.dart';
import '../entities/pre_order_entity.dart';
import '../repositories/pre_order_repository_interface.dart';

@injectable
class GetPreOrderUseCase {
  final PreOrderRepositoryInterface repository;

  const GetPreOrderUseCase({required this.repository});

  Future<PreOrderEntity?> call(String preOrderId) {
    return repository.getPreOrder(preOrderId);
  }
}
