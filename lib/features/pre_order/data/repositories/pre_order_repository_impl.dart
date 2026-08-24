import 'package:injectable/injectable.dart';
import '../../domain/entities/pre_order_entity.dart';
import '../../domain/repositories/pre_order_repository_interface.dart';
import '../data_sources/pre_order_remote_data_source_interface.dart';
import '../models/pre_order_model.dart';

@Injectable(as: PreOrderRepositoryInterface)
class PreOrderRepositoryImpl implements PreOrderRepositoryInterface {
  final PreOrderRemoteDataSourceInterface dataSource;

  PreOrderRepositoryImpl({required this.dataSource});

  @override
  Future<String> createPreOrder(PreOrderEntity preOrder) {
    final model = PreOrderModel.fromEntity(preOrder);
    return dataSource.createPreOrder(model);
  }

  @override
  Future<PreOrderEntity?> getPreOrder(String preOrderId) {
    return dataSource.getPreOrder(preOrderId);
  }

  @override
  Future<List<PreOrderEntity>> getUserPreOrders(String userId) async {
    final models = await dataSource.getUserPreOrders(userId);
    return models;
  }

  @override
  Stream<List<PreOrderEntity>> watchUserPreOrders(String userId) {
    return dataSource.watchUserPreOrders(userId);
  }

  @override
  Future<void> updatePreOrderStatus({
    required String preOrderId,
    required PreOrderStatus status,
  }) {
    return dataSource.updatePreOrderStatus(
      preOrderId: preOrderId,
      status: status,
    );
  }

  @override
  Future<void> cancelPreOrder(String preOrderId) {
    return dataSource.cancelPreOrder(preOrderId);
  }
}
