import '../entities/pre_order_entity.dart';

abstract class PreOrderRepositoryInterface {
  Future<String> createPreOrder(PreOrderEntity preOrder);

  Future<PreOrderEntity?> getPreOrder(String preOrderId);

  Future<List<PreOrderEntity>> getUserPreOrders(String userId);

  Stream<List<PreOrderEntity>> watchUserPreOrders(String userId);

  Future<void> updatePreOrderStatus({
    required String preOrderId,
    required PreOrderStatus status,
  });

  Future<void> cancelPreOrder(String preOrderId);
}
