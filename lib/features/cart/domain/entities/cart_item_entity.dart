class CartItemEntity {
  final String id;
  final String title;
  final String? customOptions;
  final double price;
  final int quantity;
  final String? imageUrl;

  const CartItemEntity({
    required this.id,
    required this.title,
    this.customOptions,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  double get totalPrice => price * quantity;

  CartItemEntity copyWith({
    String? id,
    String? title,
    String? customOptions,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      customOptions: customOptions ?? this.customOptions,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
