import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/use_cases/add_to_cart_use_case.dart';
import '../../../domain/use_cases/clear_cart_use_case.dart';
import '../../../domain/use_cases/get_cart_use_case.dart';
import '../../../domain/use_cases/remove_from_cart_use_case.dart';
import '../../../domain/use_cases/update_cart_quantity_use_case.dart';
import '../../../domain/use_cases/watch_cart_use_case.dart';

import '../../../../notifications/domain/use_cases/create_notification_use_case.dart';

import 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  final WatchCartUseCase watchCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  final RemoveFromCartUseCase removeCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final GetCartUseCase getCartUseCase;

  // Notification
  final CreateNotificationUseCase createNotificationUseCase;

  StreamSubscription<List<CartItemEntity>>? _cartSubscription;

  String _orderNotes = '';
  String? _cafeName;

  CartCubit({
    required this.watchCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartQuantityUseCase,
    required this.removeCartUseCase,
    required this.clearCartUseCase,
    required this.getCartUseCase,
    required this.createNotificationUseCase,
  }) : super(const CartInitial());

  // ============================================================
  // CART WATCHER
  // ============================================================

  void initCartWatcher({String? cafeName}) {
    if (cafeName != null) {
      _cafeName = cafeName;
    }

    emit(const CartLoading());

    _cartSubscription?.cancel();

    _cartSubscription = watchCartUseCase().listen(
      (items) {
        emit(
          CartLoaded(
            items: items,
            cafeName: _cafeName,
            orderNotes: _orderNotes,
          ),
        );
      },
      onError: (error, stackTrace) {
        emit(CartError(error.toString()));
      },
    );
  }

  // ============================================================
  // CAFE NAME
  // ============================================================

  void setCafeName(String cafeName) {
    _cafeName = cafeName;

    if (state is CartLoaded) {
      emit((state as CartLoaded).copyWith(cafeName: cafeName));
    }
  }

  // ============================================================
  // ORDER NOTES
  // ============================================================

  void setOrderNotes(String notes) {
    _orderNotes = notes;

    if (state is CartLoaded) {
      emit((state as CartLoaded).copyWith(orderNotes: notes));
    }
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> addToCart(CartItemEntity item) async {
    try {
      // 1️⃣ Add product to cart
      await addToCartUseCase(item);

      // 2️⃣ Create notification
      await _createProductAddedNotification();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ============================================================
  // PRODUCT ADDED NOTIFICATION
  // ============================================================

  Future<void> _createProductAddedNotification() async {
    final user = FirebaseAuth.instance.currentUser;

    // User must be logged in
    if (user == null) {
      return;
    }

    try {
      final result = await createNotificationUseCase(
        uid: user.uid,
        title: 'تمت إضافة المنتج 🛒',
        body: 'تمت إضافة المنتج إلى سلة المشتريات بنجاح.',
        type: 'product_added_to_cart',
      );

      result.fold(
        (failure) {
          // Notification failed
          // We don't fail the cart operation because
          // the product was already added successfully.
        },
        (_) {
          // Notification created successfully
        },
      );
    } catch (_) {
      // Don't break cart functionality if notification fails.
    }
  }

  // ============================================================
  // INCREMENT QUANTITY
  // ============================================================

  Future<void> incrementQuantity(CartItemEntity item) async {
    try {
      await updateCartQuantityUseCase(
        itemId: item.id,
        quantity: item.quantity + 1,
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ============================================================
  // DECREMENT QUANTITY
  // ============================================================

  Future<void> decrementQuantity(CartItemEntity item) async {
    try {
      if (item.quantity <= 1) {
        await removeCartUseCase(item.id);
      } else {
        await updateCartQuantityUseCase(
          itemId: item.id,
          quantity: item.quantity - 1,
        );
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ============================================================
  // UPDATE QUANTITY
  // ============================================================

  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeCartUseCase(itemId);
      } else {
        await updateCartQuantityUseCase(itemId: itemId, quantity: quantity);
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  Future<void> removeItem(String itemId) async {
    try {
      await removeCartUseCase(itemId);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  Future<void> clearCart() async {
    try {
      await clearCartUseCase();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
