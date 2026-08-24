import 'package:injectable/injectable.dart';
import '../repositories/cart_repository_interface.dart';

@injectable
class UpdateCartQuantityUseCase {
  final CartRepositoryInterface repository;

  const UpdateCartQuantityUseCase({required this.repository});

  Future<void> call({required String itemId, required int quantity}) {
    return repository.updateCartItemQuantity(
      itemId: itemId,
      quantity: quantity,
    );
  }
}
