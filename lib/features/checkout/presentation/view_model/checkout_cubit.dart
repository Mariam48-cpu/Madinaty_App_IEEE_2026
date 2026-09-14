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

  bool _isFinalizing = false;

  /*
   * يمنع تأكيد نفس عملية Paymob أكثر من مرة.
   */
  bool _paymobAlreadyConfirmed = false;

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
    if (_isFinalizing) {
      return;
    }

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
    /*
     * منع الضغط المتكرر.
     */
    if (_isFinalizing) {
      return;
    }

    /*
     * منع بدء عملية جديدة لو Paymob
     * تم تأكيدها بالفعل.
     */
    if (_paymobAlreadyConfirmed) {
      return;
    }

    _pendingCartItems = cartItems;
    _pendingOrderNotes = orderNotes;

    final isCard =
        _selectedMethod.type == PaymentType.card ||
        _selectedMethod.id == 'card';

    final isWallet =
        _selectedMethod.type == PaymentType.wallet ||
        _selectedMethod.id == 'wallet';

    if (isWallet) {
      final phone = walletDetails?.phoneNumber.trim() ?? '';

      if (phone.length != 11 || !phone.startsWith('01')) {
        emit(
          const CheckoutErrorState(
            'يرجى إدخال رقم محفظة إلكترونية صحيح '
            '(11 رقماً يبدأ بـ 01)',
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
      /*
       * ========================================================
       * CARD
       * ========================================================
       *
       * هنا لا يوجد أي Firebase Booking.
       *
       * فقط نطلب رابط Paymob.
       */
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

      /*
       * ========================================================
       * WALLET
       * ========================================================
       *
       * برضه لا يوجد أي Firebase Booking هنا.
       */
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

      /*
       * ========================================================
       * CASH
       * ========================================================
       *
       * الدفع النقدي هو الحالة الوحيدة التي نؤكد فيها
       * الحجز مباشرة بدون Paymob.
       */
      final bookingModel = BookingModel.fromEntity(_currentBooking);

      final confirmedBooking = await _confirmBookingUseCase(bookingModel);

      await _processPreOrderAndCart(confirmedBooking);

      await _createBookingNotification(confirmedBooking);

      _currentBooking = confirmedBooking;

      emit(CheckoutSuccessState(confirmedBooking));
    } catch (e) {
      emit(CheckoutErrorState(_cleanError(e)));
    }
  }

  Future<void> finalizePaymobSuccess(BookingEntity booking) async {
    /*
     * لو فيه finalize شغال بالفعل:
     * لا ننفذ مرة ثانية.
     */
    if (_isFinalizing) {
      return;
    }

    /*
     * لو العملية اتأكدت بالفعل:
     * لا ننشئ Booking ثاني.
     */
    if (_paymobAlreadyConfirmed) {
      return;
    }

    /*
     * هنا فقط نبدأ إنشاء الحجز بعد Paymob success.
     */
    _isFinalizing = true;

    emit(
      CheckoutLoadingState(
        booking: booking,
        selectedPaymentMethod: _selectedMethod,
        isSubmitting: true,
      ),
    );

    try {
      /*
       * نستخدم بيانات الحجز الأصلية.
       */
      _currentBooking = booking;

      final bookingModel = BookingModel.fromEntity(_currentBooking);

      /*
       * هنا فقط:
       *
       * Firebase Booking creation
       *
       * وقبل هذه اللحظة لا يوجد Booking.
       */
      final confirmedBooking = await _confirmBookingUseCase(bookingModel);

      /*
       * نعتبر العملية confirmed
       * فقط بعد نجاح إنشاء Booking.
       */
      _paymobAlreadyConfirmed = true;

      /*
       * Pre-order بعد نجاح الحجز فقط.
       */
      await _processPreOrderAndCart(confirmedBooking);

      /*
       * Notification بعد نجاح الحجز فقط.
       */
      await _createBookingNotification(confirmedBooking);

      _currentBooking = confirmedBooking;

      emit(CheckoutSuccessState(confirmedBooking));
    } catch (e) {
      /*
       * مهم:
       * لو إنشاء الحجز فشل، لا نعتبر Paymob
       * confirmed داخل الـ Cubit.
       */
      _paymobAlreadyConfirmed = false;

      emit(CheckoutErrorState(_cleanError(e)));
    } finally {
      _isFinalizing = false;
    }
  }

  Future<void> _createBookingNotification(BookingEntity booking) async {
    if (booking.userId.isEmpty || booking.id.isEmpty) {
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

      result.fold((_) {}, (_) {});
    } catch (_) {}
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

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '').trim();
  }
}
