import '../repositories/payment_repo_interface.dart';

class GetPaymobWalletUrlUseCase {
  final PaymentRepoInterface repository;

  GetPaymobWalletUrlUseCase(this.repository);

  Future<String> call({
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
    required String walletNumber,
  }) async {
    return await repository.getPaymobWalletUrl(
      amount: amount,
      userEmail: userEmail,
      userPhone: userPhone,
      userName: userName,
      walletNumber: walletNumber,
    );
  }
}