import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/di/injection.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cart/domain/entities/cart_item_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cart/presentation/view_model/cubit/cart_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/cart/presentation/view_model/cubit/cart_state.dart';
import 'package:madinaty_app_ieee_2026/features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/use_cases/create_pre_order_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/data/data_sources/payment_remote_data_source_impl.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/data/repositories/payment_repo_impl.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/domain/use_cases/confirm_booking_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/domain/use_cases/get_paymob_url_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/domain/use_cases/get_paymob_wallet_url_usecase.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view/screens/paymob_webview_screen.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view/screens/reservation_confirmed_screen.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view/widgets/checkout_summary_card.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view/widgets/payment_methods_section.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view/widgets/pre_orders_section.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view/widgets/reservation_details_card.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:toastification/toastification.dart';

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CheckoutCubit(
            confirmBookingUseCase: ConfirmBookingUseCase(repo),
            getPaymobUrlUseCase: GetPaymobUrlUseCase(repo),
            getPaymobWalletUrlUseCase: GetPaymobWalletUrlUseCase(repo),
            createPreOrderUseCase: getIt<CreatePreOrderUseCase>(),
            clearCartUseCase: getIt<ClearCartUseCase>(),
            initialBooking: booking,
          ),
        ),
        BlocProvider(
          create: (context) =>
              getIt<CartCubit>()..initCartWatcher(cafeName: booking.cafeId),
        ),
      ],
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
        title: Text(
          AppLocale.checkoutTitle.getString(context),
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
        listener: (context, state) async {
          if (state is CheckoutErrorState) {
            AppToast.showToast(
              context: context,
              title: AppLocale.toastError.getString(context),
              description: state.errorMessage,
              type: ToastificationType.error,
            );
          }

          if (state is CheckoutPaymobReadyState) {
            final isSuccess = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => PaymobWebViewScreen(
                  paymentUrl: state.paymentUrl,
                  booking: state.booking,
                ),
              ),
            );

            if (isSuccess == true && context.mounted) {
              context.read<CheckoutCubit>().finalizePaymobSuccess(state.booking);
            } else if (isSuccess == false && context.mounted) {
              AppToast.showToast(
                context: context,
                title: 'فشلت عملية الدفع',
                description: 'يرجى المحاولة مرة أخرى أو اختيار طريقة دفع أخرى',
                type: ToastificationType.error,
              );
            }
          }

          if (state is CheckoutSuccessState) {
            AppToast.showToast(
              context: context,
              title: AppLocale.successTitle.getString(context),
              description: AppLocale.reservationSuccessDesc.getString(context),
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
          final checkoutCubit = context.read<CheckoutCubit>();
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

          return BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              final cartCubit = context.read<CartCubit>();
              final List<CartItemEntity> cartItems = cartState is CartLoaded
                  ? cartState.items
                  : [];
              final String orderNotes = cartState is CartLoaded
                  ? cartState.orderNotes
                  : '';
              final double preOrdersAmount = cartState is CartLoaded
                  ? cartState.subtotal
                  : 0.0;

              const double reservationFee = 50.0;
              const double taxRate = 0.14;
              final double taxableAmount = reservationFee + preOrdersAmount;
              final double totalAmount = taxableAmount * (1 + taxRate);

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    ReservationDetailsCard(booking: booking),
                    if (cartItems.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      PreOrdersSection(
                        preOrderItems: cartItems,
                        onQuantityChanged: (itemId, newQuantity) {
                          if (newQuantity <= 0) {
                            cartCubit.removeItem(itemId);
                          } else {
                            cartCubit.updateQuantity(itemId, newQuantity);
                          }
                        },
                        onEditPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.cart,
                            arguments: booking.cafeId,
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 20),
                    PaymentMethodsSection(
                      selectedMethod: selectedMethod,
                      onMethodSelected: (method) {
                        checkoutCubit.selectPaymentMethod(method);
                      },
                      phoneWalletController: _phoneWalletController,
                    ),
                    const SizedBox(height: 20),
                    CheckoutSummaryCard(
                      booking: booking,
                      reservationFee: reservationFee,
                      preOrdersAmount: preOrdersAmount,
                      taxRate: taxRate,
                    ),
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
                                    phoneNumber: _phoneWalletController.text
                                        .trim(),
                                  );
                                }

                                final user = FirebaseAuth.instance.currentUser;

                                checkoutCubit.confirmAndPay(
                                  walletDetails: walletDetails,
                                  totalAmount: totalAmount,
                                  userEmail:
                                      user?.email ?? 'customer@madinaty.com',
                                  userPhone:
                                      user?.phoneNumber ?? '+201000000000',
                                  userName: user?.displayName ?? 'عميل مدينتي',
                                  cartItems: cartItems,
                                  orderNotes: orderNotes,
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
                                  const Icon(
                                    Icons.lock_outline_rounded,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocale.confirmAndPay.getString(context),
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
                        AppLocale.backToCart.getString(context),
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
