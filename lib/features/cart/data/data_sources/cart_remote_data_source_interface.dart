import '../models/cart_item_model.dart';

abstract class CartRemoteDataSourceInterface {
  Future<void> addToCart(CartItemModel item);

  Future<void> removeFromCart(String itemId);

  Future<void> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  });

  Future<void> clearCart();

  Future<List<CartItemModel>> getCart();

  Stream<List<CartItemModel>> watchCart();
}
