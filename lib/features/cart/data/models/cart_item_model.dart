import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.title,
    super.customOptions,
    required super.price,
    required super.quantity,
    super.imageUrl,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map, String id) {
    return CartItemModel(
      id: id.isNotEmpty ? id : (map['id'] ?? ''),
      title: map['title'] ?? '',
      customOptions: map['customOptions'],
      price: (map['unitPrice'] ?? map['price'] ?? 0.0).toDouble(),
      quantity: (map['quantity'] ?? 1).toInt(),
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'customOptions': customOptions,
      'unitPrice': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'totalPrice': totalPrice,
    };
  }
}
