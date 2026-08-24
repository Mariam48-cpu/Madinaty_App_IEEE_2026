import 'package:injectable/injectable.dart';
import '../repositories/cart_repository_interface.dart';

@injectable
class RemoveFromCartUseCase {
  final CartRepositoryInterface repository;

  const RemoveFromCartUseCase({required this.repository});

  Future<void> call(String itemId) {
    return repository.removeFromCart(itemId);
  }
}
