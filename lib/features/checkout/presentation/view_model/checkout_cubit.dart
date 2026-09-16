import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/features/cart/domain/entities/cart_item_entity.dart';
import 'package:madinaty_app_ieee_2026/features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/entities/pre_order_entity.dart';
import 'package:madinaty_app_ieee_2026/features/pre_order/domain/use_cases/create_pre_order_use_case.dart';

import '../../../booking/data/models/booking_model.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/use_cases/confirm_booking_usecase.dart';
import '../../domain/use_cases/get_paymob_url_usecase.dart';
import '../../domain/use_cases/get_paymob_wallet_url_usecase.dart';
import '../../../notifications/domain/use_cases/create_notification_use_case.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final ConfirmBookingUseCase _confirmBookingUseCase;
  final GetPaymobUrlUseCase _getPaymobUrlUseCase;
  final GetPaymobWalletUrlUseCase _getPaymobWalletUrlUseCase;
  final CreatePreOrderUseCase _createPreOrderUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final CreateNotificationUseCase _createNotificationUseCase;

  late BookingEntity _currentBooking;

  List<CartItemEntity> _pendingCartItems = const [];

  String _pendingOrderNotes = '';

  PaymentMethodEntity _selectedMethod = const PaymentMethodEntity(
    id: 'card',
    title: 'بطاقة ائتمان / خصم مباشر',
    type: PaymentType.card,
    isSelected: true,
  );

  CheckoutCubit({
    required ConfirmBookingUseCase confirmBookingUseCase,
    required GetPaymobUrlUseCase getPaymobUrlUseCase,
    required GetPaymobWalletUrlUseCase getPaymobWalletUrlUseCase,
    required CreatePreOrderUseCase createPreOrderUseCase,
    required ClearCartUseCase clearCartUseCase,
    required CreateNotificationUseCase createNotificationUseCase,
    required BookingEntity initialBooking,
  }) : _confirmBookingUseCase = confirmBookingUseCase,
        _getPaymobUrlUseCase = getPaymobUrlUseCase,
        _getPaymobWalletUrlUseCase = getPaymobWalletUrlUseCase,
        _createPreOrderUseCase = createPreOrderUseCase,
        _clearCartUseCase = clearCartUseCase,
        _createNotificationUseCase = createNotificationUseCase,
        super(
        CheckoutLoadingState(
          booking: initialBooking,
          selectedPaymentMethod: const PaymentMethodEntity(
            id: 'card',
            title: 'بطاقة ائتمان / خصم مباشر',
            type: PaymentType.card,
            isSelected: true,
          ),
        ),
      ) {
    _currentBooking = initialBooking;
  }

  void selectPaymentMethod(PaymentMethodEntity method) {
    _selectedMethod = method;

    emit(
      CheckoutLoadingState(
        booking: _currentBooking,
        selectedPaymentMethod: _selectedMethod,
        isSubmitting: false,
      ),
    );
  }

  Future<void> confirmAndPay({
    WalletPaymentDetails? walletDetails,
    double totalAmount = 50.0,
    String userEmail = '',
    String userPhone = '',
    String userName = '',
    List<CartItemEntity> cartItems = const [],
    String orderNotes = '',
  }) async {
    _pendingCartItems = cartItems;
    _pendingOrderNotes = orderNotes;

    final isCard =
        _selectedMethod.type == PaymentType.card ||
            _selectedMethod.id == 'card';

    final isWallet =
        _selectedMethod.type == PaymentType.wallet ||
            _selectedMethod.id == 'wallet';

    if (isWallet) {
      if (walletDetails == null ||
          walletDetails.phoneNumber.trim().length != 11 ||
          !walletDetails.phoneNumber.trim().startsWith('01')) {
        emit(
          const CheckoutErrorState(
            'يرجى إدخال رقم محفظة إلكترونية صحيح (11 رقماً يبدأ بـ 01)',
          ),
        );
        return;
      }
    }

    emit(
      CheckoutLoadingState(
        booking: _currentBooking,
        selectedPaymentMethod: _selectedMethod,
        isSubmitting: true,
      ),
    );

    try {
      if (isCard) {
        final paymentUrl = await _getPaymobUrlUseCase(
          amount: totalAmount > 0 ? totalAmount : 50.0,
          userEmail: userEmail,
          userPhone: userPhone,
          userName: userName,
        );

        emit(
          CheckoutPaymobReadyState(
            paymentUrl: paymentUrl,
            booking: _currentBooking,
          ),
        );

        return;
      }

      if (isWallet) {
        final walletNumber = walletDetails?.phoneNumber.trim() ?? '';

        final redirectUrl = await _getPaymobWalletUrlUseCase(
          amount: totalAmount > 0 ? totalAmount : 50.0,
          userEmail: userEmail,
          userPhone: userPhone,
          userName: userName,
          walletNumber: walletNumber,
        );

        emit(
          CheckoutPaymobReadyState(
            paymentUrl: redirectUrl,
            booking: _currentBooking,
          ),
        );

        return;
      }

      final bookingModel = BookingModel.fromEntity(_currentBooking);

      final confirmedBooking = await _confirmBookingUseCase(bookingModel);
      await _processPreOrderAndCart(confirmedBooking);
      await _createBookingNotification(confirmedBooking);

      emit(CheckoutSuccessState(confirmedBooking));
    } catch (e) {
      emit(CheckoutErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> finalizePaymobSuccess(BookingEntity booking) async {
    emit(
      CheckoutLoadingState(
        booking: booking,
        selectedPaymentMethod: _selectedMethod,
        isSubmitting: true,
      ),
    );

    try {
      final bookingModel = BookingModel.fromEntity(booking);

      final confirmedBooking = await _confirmBookingUseCase(bookingModel);
      await _processPreOrderAndCart(confirmedBooking);

      await _createBookingNotification(confirmedBooking);

      emit(CheckoutSuccessState(confirmedBooking));
    } catch (e) {
      emit(CheckoutErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _createBookingNotification(BookingEntity booking) async {
    if (booking.userId.isEmpty) {
      return;
    }

    try {
      final result = await _createNotificationUseCase(
        uid: booking.userId,
        title: 'تم تأكيد الحجز',
        body: 'تم تأكيد حجزك بنجاح. نتمنى لك وقتاً ممتعاً في الكافيه.',
        type: 'booking_confirmed',
        bookingId: booking.id,
      );

      result.fold(
            (failure) {
        },
            (_) {
        },
      );
    } catch (_) {
    }
  }

  Future<void> _processPreOrderAndCart(BookingEntity confirmedBooking) async {
    if (_pendingCartItems.isEmpty) {
      return;
    }

    DateTime? pickupDateTime = confirmedBooking.date;

    final bookingTime = confirmedBooking.time;

    if (confirmedBooking.date != null &&
        bookingTime != null &&
        bookingTime.isNotEmpty) {
      final parts = bookingTime.split(':');

      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);

        if (hour != null && minute != null) {
          final date = confirmedBooking.date!;

          pickupDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            hour,
            minute,
          );
        }
      }
    }

    final preOrder = PreOrderEntity(
      id: '',
      userId: confirmedBooking.userId,
      cafeId: confirmedBooking.cafeId,
      bookingId: confirmedBooking.id,
      items: _pendingCartItems,
      orderNotes: _pendingOrderNotes.isNotEmpty ? _pendingOrderNotes : null,
      serviceFeeRate: 0.14,
      status: PreOrderStatus.confirmed,
      createdAt: DateTime.now(),
      pickupTime: pickupDateTime,
    );

    await _createPreOrderUseCase(preOrder);

    await _clearCartUseCase();
  }
}
