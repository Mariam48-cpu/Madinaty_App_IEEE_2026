import 'package:injectable/injectable.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository_interface.dart';
import '../data_sources/cart_remote_data_source_interface.dart';
import '../models/cart_item_model.dart';

@Injectable(as: CartRepositoryInterface)
class CartRepositoryImpl implements CartRepositoryInterface {
  final CartRemoteDataSourceInterface dataSource;

  CartRepositoryImpl({required this.dataSource});

  @override
  Future<void> addToCart(CartItemEntity item) {
    final model = CartItemModel.fromEntity(item);
    return dataSource.addToCart(model);
  }

  @override
  Future<void> removeFromCart(String itemId) {
    return dataSource.removeFromCart(itemId);
  }

  @override
  Future<void> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  }) {
    return dataSource.updateCartItemQuantity(
      itemId: itemId,
      quantity: quantity,
    );
  }

  @override
  Future<void> clearCart() {
    return dataSource.clearCart();
  }

  @override
  Future<List<CartItemEntity>> getCart() async {
    final models = await dataSource.getCart();
    return models;
  }

  @override
  Stream<List<CartItemEntity>> watchCart() {
    return dataSource.watchCart();
  }
}
