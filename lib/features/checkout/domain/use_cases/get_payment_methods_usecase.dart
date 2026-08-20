import '../entities/payment_method_entity.dart';
import '../repositories/payment_repo_interface.dart';

class GetPaymentMethodsUsecase {
  final PaymentRepoInterface repo;

  GetPaymentMethodsUsecase(this.repo);

  Future<List<PaymentMethodEntity>> call() async {
    return await repo.getPaymentMethods();
  }
}
