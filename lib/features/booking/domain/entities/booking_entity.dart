
import '../../../cart/domain/entities/cart_item_entity.dart';

class BookingEntity {
  final String? id;
  final String userId;
  final String cafeId;
  final String cafeName;
  final String cafeAddress;
  final String? cafeImageUrl;
  final DateTime bookingDateTime;
  final int guestsCount;
  final String seatingPreference;
  final String? occasion;
  final List<CartItemEntity> preOrderItems;
  final double tableReservationFee;
  final double taxRate;
  final String status;
  final String? paymentMethodId;
  final String? idempotencyKey;

  const BookingEntity({
    this.id,
    required this.userId,
    required this.cafeId,
    required this.cafeName,
    required this.cafeAddress,
    this.cafeImageUrl,
    required this.bookingDateTime,
    required this.guestsCount,
    required this.seatingPreference,
    this.occasion,
    this.preOrderItems = const [],
    this.tableReservationFee = 50.0,
    this.taxRate = 0.14,
    this.status = 'pending',
    this.paymentMethodId,
    this.idempotencyKey,
  });

  double get preOrdersSubtotal => preOrderItems.fold(
    0.0,
        (sum, item) => sum + item.totalPrice,
  );

  double get taxAmount => (preOrdersSubtotal + tableReservationFee) * taxRate;

  double get totalAmount => preOrdersSubtotal + tableReservationFee + taxAmount;

  BookingEntity copyWith({
    String? id,
    String? userId,
    String? cafeId,
    String? cafeName,
    String? cafeAddress,
    String? cafeImageUrl,
    DateTime? bookingDateTime,
    int? guestsCount,
    String? seatingPreference,
    String? occasion,
    List<CartItemEntity>? preOrderItems,
    double? tableReservationFee,
    double? taxRate,
    String? status,
    String? paymentMethodId,
    String? idempotencyKey,
  }) {
    return BookingEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cafeId: cafeId ?? this.cafeId,
      cafeName: cafeName ?? this.cafeName,
      cafeAddress: cafeAddress ?? this.cafeAddress,
      cafeImageUrl: cafeImageUrl ?? this.cafeImageUrl,
      bookingDateTime: bookingDateTime ?? this.bookingDateTime,
      guestsCount: guestsCount ?? this.guestsCount,
      seatingPreference: seatingPreference ?? this.seatingPreference,
      occasion: occasion ?? this.occasion,
      preOrderItems: preOrderItems ?? this.preOrderItems,
      tableReservationFee: tableReservationFee ?? this.tableReservationFee,
      taxRate: taxRate ?? this.taxRate,
      status: status ?? this.status,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    );
  }
}
