import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../models/cart_item_model.dart';
import 'cart_remote_data_source_interface.dart';

@Injectable(as: CartRemoteDataSourceInterface)
class CartRemoteDataSourceImpl implements CartRemoteDataSourceInterface {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartRemoteDataSourceImpl();

  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _userCartCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart');
  }

  String _requireUserId() {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty) {
      throw Exception('يجب تسجيل الدخول لإتمام عملية السلة');
    }
    return uid;
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    final uid = _requireUserId();
    final docRef = _userCartCollection(uid).doc(item.id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final existingItem = CartItemModel.fromFirestore(docSnapshot);
      final newQuantity = existingItem.quantity + item.quantity;
      await docRef.update({
        'quantity': newQuantity,
        'totalPrice': existingItem.price * newQuantity,
      });
    } else {
      await docRef.set(item.toMap());
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    final uid = _requireUserId();
    await _userCartCollection(uid).doc(itemId).delete();
  }

  @override
  Future<void> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    final uid = _requireUserId();
    final docRef = _userCartCollection(uid).doc(itemId);

    if (quantity <= 0) {
      await docRef.delete();
    } else {
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final existingItem = CartItemModel.fromFirestore(docSnapshot);
        await docRef.update({
          'quantity': quantity,
          'totalPrice': existingItem.price * quantity,
        });
      } else {
        await docRef.update({'quantity': quantity});
      }
    }
  }

  @override
  Future<void> clearCart() async {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty) return;

    try {
      final snapshot = await _userCartCollection(uid).get();
      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (_) {}
  }

  @override
  Future<List<CartItemModel>> getCart() async {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty) {
      return [];
    }

    try {
      final snapshot = await _userCartCollection(uid).get();
      return snapshot.docs
          .map((doc) => CartItemModel.fromFirestore(doc))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Stream<List<CartItemModel>> watchCart() {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty) {
      return Stream.value([]);
    }

    try {
      return _userCartCollection(uid).snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => CartItemModel.fromFirestore(doc))
            .toList();
      }).handleError((_) => <CartItemModel>[]);
    } catch (_) {
      return Stream.value([]);
    }
  }
}
