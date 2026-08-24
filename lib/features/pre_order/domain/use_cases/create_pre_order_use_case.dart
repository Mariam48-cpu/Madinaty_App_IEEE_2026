import 'package:injectable/injectable.dart';
import '../entities/pre_order_entity.dart';
import '../repositories/pre_order_repository_interface.dart';

@injectable
class CreatePreOrderUseCase {
  final PreOrderRepositoryInterface repository;

  const CreatePreOrderUseCase({required this.repository});

  Future<String> call(PreOrderEntity preOrder) {
    return repository.createPreOrder(preOrder);
  }
}
