import '../../../domain/entities/cart_item_entity.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  final String? cafeName;
  final String orderNotes;
  final double serviceFeeRate;

  const CartLoaded({
    required this.items,
    this.cafeName,
    this.orderNotes = '',
    this.serviceFeeRate = 0.14,
  });

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get serviceFee =>
      subtotal > 0 ? (subtotal * serviceFeeRate) : 0.0;

  double get total => subtotal > 0 ? subtotal + serviceFee : 0.0;

  int get totalItemsCount =>
      items.fold(0, (count, item) => count + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartLoaded copyWith({
    List<CartItemEntity>? items,
    String? cafeName,
    String? orderNotes,
    double? serviceFeeRate,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      cafeName: cafeName ?? this.cafeName,
      orderNotes: orderNotes ?? this.orderNotes,
      serviceFeeRate: serviceFeeRate ?? this.serviceFeeRate,
    );
  }
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);
}
