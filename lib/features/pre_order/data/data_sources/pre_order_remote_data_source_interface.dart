import '../../domain/entities/pre_order_entity.dart';
import '../models/pre_order_model.dart';

abstract class PreOrderRemoteDataSourceInterface {
  Future<String> createPreOrder(PreOrderModel preOrder);

  Future<PreOrderModel?> getPreOrder(String preOrderId);

  Future<List<PreOrderModel>> getUserPreOrders(String userId);

  Stream<List<PreOrderModel>> watchUserPreOrders(String userId);

  Future<void> updatePreOrderStatus({
    required String preOrderId,
    required PreOrderStatus status,
  });

  Future<void> cancelPreOrder(String preOrderId);
}
