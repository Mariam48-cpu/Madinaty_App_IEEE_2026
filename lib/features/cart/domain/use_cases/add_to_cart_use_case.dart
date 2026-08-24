import 'package:injectable/injectable.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository_interface.dart';

@injectable
class AddToCartUseCase {
  final CartRepositoryInterface repository;

  const AddToCartUseCase({required this.repository});

  Future<void> call(CartItemEntity item) {
    return repository.addToCart(item);
  }
}
