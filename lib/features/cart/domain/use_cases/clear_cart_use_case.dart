import 'package:injectable/injectable.dart';
import '../repositories/cart_repository_interface.dart';

@injectable
class ClearCartUseCase {
  final CartRepositoryInterface repository;

  const ClearCartUseCase({required this.repository});

  Future<void> call() {
    return repository.clearCart();
  }
}
