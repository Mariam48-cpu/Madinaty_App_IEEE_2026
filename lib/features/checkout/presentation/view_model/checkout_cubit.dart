import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/presentation/view_model/checkout_state.dart';
import '../../../booking/data/models/booking_model.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/use_cases/confirm_booking_usecase.dart';
import '../../domain/use_cases/get_paymob_url_usecase.dart';
import '../../domain/use_cases/get_paymob_wallet_url_usecase.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final ConfirmBookingUseCase _confirmBookingUseCase;
  final GetPaymobUrlUseCase _getPaymobUrlUseCase;
  final GetPaymobWalletUrlUseCase _getPaymobWalletUrlUseCase;

  late BookingEntity _currentBooking;
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
    required BookingEntity initialBooking,
  })  : _confirmBookingUseCase = confirmBookingUseCase,
        _getPaymobUrlUseCase = getPaymobUrlUseCase,
        _getPaymobWalletUrlUseCase = getPaymobWalletUrlUseCase,
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
  }) async {
    final isCard =
        _selectedMethod.type == PaymentType.card ||
            _selectedMethod.id == 'card';
    final isWallet =
        _selectedMethod.id == 'wallet' ||
            _selectedMethod.type == PaymentType.wallet;

    if (isWallet) {
      if (walletDetails == null ||
          walletDetails.phoneNumber.trim().length != 11 ||
          !walletDetails.phoneNumber.trim().startsWith('01')) {
        emit(
          const CheckoutErrorState(
            "يرجى إدخال رقم محفظة إلكترونية صحيح (11 رقماً يبدأ بـ 01)",
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
          CheckoutLoadingState(
            booking: _currentBooking,
            selectedPaymentMethod: _selectedMethod,
            isSubmitting: false,
          ),
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
          CheckoutLoadingState(
            booking: _currentBooking,
            selectedPaymentMethod: _selectedMethod,
            isSubmitting: false,
          ),
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
      emit(CheckoutSuccessState(confirmedBooking));
    } catch (e) {
      emit(
        CheckoutLoadingState(
          booking: _currentBooking,
          selectedPaymentMethod: _selectedMethod,
          isSubmitting: false,
        ),
      );
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
      emit(CheckoutSuccessState(confirmedBooking));
    } catch (e) {
      emit(
        CheckoutLoadingState(
          booking: _currentBooking,
          selectedPaymentMethod: _selectedMethod,
          isSubmitting: false,
        ),
      );
      emit(CheckoutErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}