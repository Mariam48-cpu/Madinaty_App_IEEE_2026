import 'package:injectable/injectable.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository_interface.dart';

@injectable
class WatchCartUseCase {
  final CartRepositoryInterface repository;

  const WatchCartUseCase(CartRepositoryInterface cartRepositoryInterface, {required this.repository});

  Stream<List<CartItemEntity>> call() {
    return repository.watchCart();
  }
}
