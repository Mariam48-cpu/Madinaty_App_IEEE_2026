import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/pre_order_entity.dart';
import '../models/pre_order_model.dart';
import 'pre_order_remote_data_source_interface.dart';

@Injectable(as: PreOrderRemoteDataSourceInterface)
class PreOrderRemoteDataSourceImpl
    implements PreOrderRemoteDataSourceInterface {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PreOrderRemoteDataSourceImpl();

  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _userPreOrdersCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('pre_orders');
  }

  String _requireUserId() {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty) {
      throw Exception('يجب تسجيل الدخول لإتمام الطلب المسبق');
    }
    return uid;
  }

  @override
  Future<String> createPreOrder(PreOrderModel preOrder) async {
    final uid = _requireUserId();
    final docRef = preOrder.id.isNotEmpty
        ? _userPreOrdersCollection(uid).doc(preOrder.id)
        : _userPreOrdersCollection(uid).doc();

    final data = preOrder.toMap();
    data['id'] = docRef.id;
    data['userId'] = uid;

    await docRef.set(data);
    return docRef.id;
  }

  @override
  Future<PreOrderModel?> getPreOrder(String preOrderId) async {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty) {
      return null;
    }

    try {
      final doc = await _userPreOrdersCollection(uid).doc(preOrderId).get();
      if (!doc.exists) return null;
      return PreOrderModel.fromFirestore(doc);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<PreOrderModel>> getUserPreOrders(String userId) async {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty || uid != userId) {
      return [];
    }

    try {
      final snapshot = await _userPreOrdersCollection(uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PreOrderModel.fromFirestore(doc))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Stream<List<PreOrderModel>> watchUserPreOrders(String userId) {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty || uid != userId) {
      return Stream.value([]);
    }

    try {
      return _userPreOrdersCollection(uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PreOrderModel.fromFirestore(doc))
            .toList();
      }).handleError((_) => <PreOrderModel>[]);
    } catch (_) {
      return Stream.value([]);
    }
  }

  @override
  Future<void> updatePreOrderStatus({
    required String preOrderId,
    required PreOrderStatus status,
  }) async {
    final uid = _requireUserId();
    await _userPreOrdersCollection(uid).doc(preOrderId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> cancelPreOrder(String preOrderId) async {
    final uid = _requireUserId();
    await _userPreOrdersCollection(uid).doc(preOrderId).update({
      'status': PreOrderStatus.cancelled.name,
      'cancelledAt': FieldValue.serverTimestamp(),
    });
  }
}
