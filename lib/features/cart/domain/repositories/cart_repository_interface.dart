import '../entities/cart_item_entity.dart';

abstract class CartRepositoryInterface {
  Future<void> addToCart(CartItemEntity item);

  Future<void> removeFromCart(String itemId);

  Future<void> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  });

  Future<void> clearCart();

  Future<List<CartItemEntity>> getCart();

  Stream<List<CartItemEntity>> watchCart();
}
