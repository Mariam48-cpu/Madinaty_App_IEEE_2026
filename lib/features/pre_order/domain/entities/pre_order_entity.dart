import 'package:madinaty_app_ieee_2026/features/cart/domain/entities/cart_item_entity.dart';

enum PreOrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  completed,
  cancelled,
}

class PreOrderEntity {
  final String id;
  final String userId;
  final String cafeId;
  final String? bookingId;
  final List<CartItemEntity> items;
  final String? orderNotes;
  final double serviceFeeRate;
  final PreOrderStatus status;
  final DateTime? createdAt;
  final DateTime? pickupTime;

  const PreOrderEntity({
    required this.id,
    required this.userId,
    required this.cafeId,
    this.bookingId,
    required this.items,
    this.orderNotes,
    this.serviceFeeRate = 0.14,
    this.status = PreOrderStatus.pending,
    this.createdAt,
    this.pickupTime,
  });

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get serviceFee =>
      subtotal > 0 ? (subtotal * serviceFeeRate) : 0.0;

  double get totalAmount => subtotal > 0 ? subtotal + serviceFee : 0.0;

  int get totalItemsCount =>
      items.fold(0, (count, item) => count + item.quantity);

  bool get isEmpty => items.isEmpty;

  PreOrderEntity copyWith({
    String? id,
    String? userId,
    String? cafeId,
    String? bookingId,
    List<CartItemEntity>? items,
    String? orderNotes,
    double? serviceFeeRate,
    PreOrderStatus? status,
    DateTime? createdAt,
    DateTime? pickupTime,
  }) {
    return PreOrderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cafeId: cafeId ?? this.cafeId,
      bookingId: bookingId ?? this.bookingId,
      items: items ?? this.items,
      orderNotes: orderNotes ?? this.orderNotes,
      serviceFeeRate: serviceFeeRate ?? this.serviceFeeRate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      pickupTime: pickupTime ?? this.pickupTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreOrderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          cafeId == other.cafeId &&
          bookingId == other.bookingId &&
          orderNotes == other.orderNotes &&
          serviceFeeRate == other.serviceFeeRate &&
          status == other.status &&
          createdAt == other.createdAt &&
          pickupTime == other.pickupTime;

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        cafeId,
        bookingId,
        orderNotes,
        serviceFeeRate,
        status,
        createdAt,
        pickupTime,
      );
}
