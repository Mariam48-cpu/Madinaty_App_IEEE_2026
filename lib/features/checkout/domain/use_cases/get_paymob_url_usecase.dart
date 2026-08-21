import 'package:madinaty_app_ieee_2026/features/checkout/domain/repositories/payment_repo_interface.dart';

class GetPaymobUrlUseCase {
  final PaymentRepoInterface repo;

  GetPaymobUrlUseCase(this.repo);

  Future<String> call({
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
  }) async {
    return await repo.getPaymobUrl(
      amount: amount,
      userEmail: userEmail,
      userPhone: userPhone,
      userName: userName,
    );
  }
}
