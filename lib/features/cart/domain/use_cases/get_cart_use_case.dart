import 'package:injectable/injectable.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository_interface.dart';

@injectable
class GetCartUseCase {
  final CartRepositoryInterface repository;

  const GetCartUseCase({required this.repository});

  Future<List<CartItemEntity>> call() {
    return repository.getCart();
  }
}
