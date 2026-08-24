import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/use_cases/add_to_cart_use_case.dart';
import '../../../domain/use_cases/clear_cart_use_case.dart';
import '../../../domain/use_cases/get_cart_use_case.dart';
import '../../../domain/use_cases/remove_from_cart_use_case.dart';
import '../../../domain/use_cases/update_cart_quantity_use_case.dart';
import '../../../domain/use_cases/watch_cart_use_case.dart';
import 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  final WatchCartUseCase watchCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  final RemoveFromCartUseCase removeCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final GetCartUseCase getCartUseCase;

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
  }) : super(const CartInitial());

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

  void setCafeName(String cafeName) {
    _cafeName = cafeName;
    if (state is CartLoaded) {
      emit((state as CartLoaded).copyWith(cafeName: cafeName));
    }
  }

  void setOrderNotes(String notes) {
    _orderNotes = notes;
    if (state is CartLoaded) {
      emit((state as CartLoaded).copyWith(orderNotes: notes));
    }
  }

  Future<void> addToCart(CartItemEntity item) async {
    try {
      await addToCartUseCase(item);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

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

  Future<void> removeItem(String itemId) async {
    try {
      await removeCartUseCase(itemId);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> clearCart() async {
    try {
      await clearCartUseCase();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
