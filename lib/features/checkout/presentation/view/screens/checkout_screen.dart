import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view/screens/paymob_webview_screen.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view/screens/reservation_confirmed_screen.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/utils/app_toast.dart';
import '../../../../booking/domain/entities/booking_entity.dart';
import '../../../data/data_sources/payment_remote_data_source_impl.dart';
import '../../../data/repositories/payment_repo_impl.dart';
import '../../../domain/entities/payment_method_entity.dart';
import '../../../domain/use_cases/confirm_booking_usecase.dart';
import '../../../domain/use_cases/get_paymob_url_usecase.dart';
import '../../../domain/use_cases/get_paymob_wallet_url_usecase.dart';
import '../../view_model/checkout_cubit.dart';
import '../../view_model/checkout_state.dart';
import '../widgets/reservation_details_card.dart';
import '../widgets/payment_methods_section.dart';
import '../widgets/checkout_summary_card.dart';

class CheckoutScreen extends StatelessWidget {
  final BookingEntity booking;

  const CheckoutScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final dataSource = PaymentRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    );
    final repo = PaymentRepoImpl(paymentDataSource: dataSource);

    return BlocProvider(
      create: (context) => CheckoutCubit(
        confirmBookingUseCase: ConfirmBookingUseCase(repo),
        getPaymobUrlUseCase: GetPaymobUrlUseCase(repo),
        getPaymobWalletUrlUseCase: GetPaymobWalletUrlUseCase(repo),
        initialBooking: booking,
      ),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView();

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  late final TextEditingController _phoneWalletController;
  BookingEntity? _cachedBooking;

  @override
  void initState() {
    super.initState();
    _phoneWalletController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneWalletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الدفع وتأكيد الحجز',
          style: AppTypography.titleLarge,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.surfaceVariant,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutErrorState) {
            AppToast.showToast(
              context: context,
              title: 'خطأ في عملية الدفع',
              description: state.errorMessage,
              type: ToastificationType.error,
            );
          }

          if (state is CheckoutPaymobReadyState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymobWebViewScreen(
                  paymentUrl: state.paymentUrl,
                  booking: state.booking,
                  onPaymentSuccess: (confirmedBooking) {
                    context.read<CheckoutCubit>().finalizePaymobSuccess(
                      confirmedBooking,
                    );
                  },
                ),
              ),
            );
          }

          if (state is CheckoutSuccessState) {
            AppToast.showToast(
              context: context,
              title: 'تم بنجاح',
              description: 'تم تأكيد حجزك بنجاح!',
              type: ToastificationType.success,
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) =>
                    ReservationConfirmedScreen(booking: state.confirmedBooking),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoadingState) {
            _cachedBooking = state.booking;
          }

          if (_cachedBooking == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final booking = _cachedBooking!;
          final cubit = context.read<CheckoutCubit>();
          final isSubmitting =
              state is CheckoutLoadingState && state.isSubmitting;
          final selectedMethod = state is CheckoutLoadingState
              ? state.selectedPaymentMethod
              : const PaymentMethodEntity(
                  id: 'card',
                  title: 'بطاقة ائتمان / خصم مباشر',
                  type: PaymentType.card,
                  isSelected: true,
                );

          // المبلغ الافتراضي لرسوم حجز الطاولة
          const double reservationFee = 50.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                ReservationDetailsCard(booking: booking),
                const SizedBox(height: 20),

                PaymentMethodsSection(
                  selectedMethod: selectedMethod,
                  onMethodSelected: (method) {
                    cubit.selectPaymentMethod(method);
                  },
                  phoneWalletController: _phoneWalletController,
                ),
                const SizedBox(height: 20),

                CheckoutSummaryCard(booking: booking),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            WalletPaymentDetails? walletDetails;
                            if (selectedMethod.type == PaymentType.wallet ||
                                selectedMethod.id == 'wallet') {
                              walletDetails = WalletPaymentDetails(
                                phoneNumber: _phoneWalletController.text.trim(),
                              );
                            }

                            final user = FirebaseAuth.instance.currentUser;

                            cubit.confirmAndPay(
                              walletDetails: walletDetails,
                              totalAmount: reservationFee,
                              userEmail: user?.email ?? 'customer@madinaty.com',
                              userPhone: user?.phoneNumber ?? '+201000000000',
                              userName: user?.displayName ?? 'عميل مدينتي',
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkButton,
                      foregroundColor: AppColors.onDarkButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.textWhite,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock_outline_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'تأكيد والدفع',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.onDarkButton,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'العودة',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
