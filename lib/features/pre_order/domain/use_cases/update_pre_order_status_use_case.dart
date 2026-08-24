import 'package:injectable/injectable.dart';
import '../entities/pre_order_entity.dart';
import '../repositories/pre_order_repository_interface.dart';

@injectable
class UpdatePreOrderStatusUseCase {
  final PreOrderRepositoryInterface repository;

  const UpdatePreOrderStatusUseCase({required this.repository});

  Future<void> call({
    required String preOrderId,
    required PreOrderStatus status,
  }) {
    return repository.updatePreOrderStatus(
      preOrderId: preOrderId,
      status: status,
    );
  }
}
