import '../../../cart/data/models/cart_item_model.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    super.id,
    required super.userId,
    required super.cafeId,
    required super.cafeName,
    required super.cafeAddress,
    super.cafeImageUrl,
    required super.bookingDateTime,
    required super.guestsCount,
    required super.seatingPreference,
    super.occasion,
    super.preOrderItems = const [],
    super.tableReservationFee = 50.0,
    super.taxRate = 0.14,
    super.status = 'pending',
    super.paymentMethodId,
    super.idempotencyKey,
  });

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      userId: entity.userId,
      cafeId: entity.cafeId,
      cafeName: entity.cafeName,
      cafeAddress: entity.cafeAddress,
      cafeImageUrl: entity.cafeImageUrl,
      bookingDateTime: entity.bookingDateTime,
      guestsCount: entity.guestsCount,
      seatingPreference: entity.seatingPreference,
      occasion: entity.occasion,
      preOrderItems: entity.preOrderItems,
      tableReservationFee: entity.tableReservationFee,
      taxRate: entity.taxRate,
      status: entity.status,
      paymentMethodId: entity.paymentMethodId,
      idempotencyKey: entity.idempotencyKey,
    );
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookingModel(
      id: docId,
      userId: map['userId'] ?? '',
      cafeId: map['cafeId'] ?? '',
      cafeName: map['cafeName'] ?? '',
      cafeAddress: map['cafeAddress'] ?? '',
      cafeImageUrl: map['cafeImageUrl'],
      bookingDateTime: map['bookingDateTime'] != null
          ? DateTime.parse(map['bookingDateTime'])
          : DateTime.now(),
      guestsCount: (map['guestsCount'] ?? 1).toInt(),
      seatingPreference: map['seatingPreference'] ?? '',
      occasion: map['occasion'],
      preOrderItems: (map['preOrderItems'] as List<dynamic>? ?? [])
          .map((item) => CartItemModel.fromMap(item as Map<String, dynamic>, item['id'] ?? ''))
          .toList(),
      tableReservationFee: (map['tableReservationFee'] ?? 50.0).toDouble(),
      taxRate: (map['taxRate'] ?? 0.14).toDouble(),
      status: map['status'] ?? 'pending',
      paymentMethodId: map['paymentMethodId'],
      idempotencyKey: map['idempotencyKey'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cafeId': cafeId,
      'cafeName': cafeName,
      'cafeAddress': cafeAddress,
      'cafeImageUrl': cafeImageUrl,
      'bookingDateTime': bookingDateTime.toIso8601String(),
      'guestsCount': guestsCount,
      'seatingPreference': seatingPreference,
      'occasion': occasion,
      'preOrderItems': preOrderItems.map((item) {
        if (item is CartItemModel) {
          return item.toMap();
        }
        return CartItemModel(
          id: item.id,
          title: item.title,
          customOptions: item.customOptions,
          price: item.price,
          quantity: item.quantity,
          imageUrl: item.imageUrl,
        ).toMap();
      }).toList(),
      'tableReservationFee': tableReservationFee,
      'preOrdersSubtotal': preOrdersSubtotal,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethodId': paymentMethodId,
      'idempotencyKey': idempotencyKey,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
