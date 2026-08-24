import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madinaty_app_ieee_2026/features/cart/data/models/cart_item_model.dart';
import '../../domain/entities/pre_order_entity.dart';

class PreOrderModel extends PreOrderEntity {
  const PreOrderModel({
    required super.id,
    required super.userId,
    required super.cafeId,
    super.bookingId,
    required super.items,
    super.orderNotes,
    super.serviceFeeRate,
    super.status,
    super.createdAt,
    super.pickupTime,
  });

  factory PreOrderModel.fromEntity(PreOrderEntity entity) {
    return PreOrderModel(
      id: entity.id,
      userId: entity.userId,
      cafeId: entity.cafeId,
      bookingId: entity.bookingId,
      items: entity.items,
      orderNotes: entity.orderNotes,
      serviceFeeRate: entity.serviceFeeRate,
      status: entity.status,
      createdAt: entity.createdAt,
      pickupTime: entity.pickupTime,
    );
  }

  factory PreOrderModel.fromMap(Map<String, dynamic> map, String docId) {
    final rawItems = map['items'];
    final itemsList = <CartItemModel>[];
    if (rawItems is List) {
      for (final raw in rawItems) {
        if (raw is Map<String, dynamic>) {
          itemsList.add(CartItemModel.fromMap(raw, raw['id'] ?? ''));
        }
      }
    }

    final statusStr = map['status'] as String? ?? 'pending';
    final status = PreOrderStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => PreOrderStatus.pending,
    );

    DateTime? createdAt;
    final rawCreated = map['createdAt'];
    if (rawCreated is Timestamp) {
      createdAt = rawCreated.toDate();
    } else if (rawCreated is String) {
      createdAt = DateTime.tryParse(rawCreated);
    }

    DateTime? pickupTime;
    final rawPickup = map['pickupTime'];
    if (rawPickup is Timestamp) {
      pickupTime = rawPickup.toDate();
    } else if (rawPickup is String) {
      pickupTime = DateTime.tryParse(rawPickup);
    }

    return PreOrderModel(
      id: docId.isNotEmpty ? docId : (map['id'] ?? ''),
      userId: map['userId'] ?? '',
      cafeId: map['cafeId'] ?? '',
      bookingId: map['bookingId'],
      items: itemsList,
      orderNotes: map['orderNotes'],
      serviceFeeRate: (map['serviceFeeRate'] ?? 0.14).toDouble(),
      status: status,
      createdAt: createdAt,
      pickupTime: pickupTime,
    );
  }

  factory PreOrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return PreOrderModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cafeId': cafeId,
      'bookingId': bookingId,
      'items': items.map((item) => CartItemModel.fromEntity(item).toMap()).toList(),
      'orderNotes': orderNotes,
      'subtotal': subtotal,
      'serviceFee': serviceFee,
      'serviceFeeRate': serviceFeeRate,
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'pickupTime': pickupTime != null ? Timestamp.fromDate(pickupTime!) : null,
    };
  }
}
