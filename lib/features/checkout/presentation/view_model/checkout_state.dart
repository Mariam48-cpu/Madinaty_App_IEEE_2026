import '../../../../features/booking/domain/entities/booking_entity.dart';
import '../../domain/entities/payment_method_entity.dart';

abstract class CheckoutState {
  const CheckoutState();
}

class CheckoutInitialState extends CheckoutState {
  const CheckoutInitialState();
}

class CheckoutLoadingState extends CheckoutState {
  final BookingEntity booking;
  final PaymentMethodEntity selectedPaymentMethod;
  final bool isSubmitting;

  const CheckoutLoadingState({
    required this.booking,
    required this.selectedPaymentMethod,
    this.isSubmitting = false,
  });

  CheckoutLoadingState copyWith({
    BookingEntity? booking,
    PaymentMethodEntity? selectedPaymentMethod,
    bool? isSubmitting,
  }) {
    return CheckoutLoadingState(
      booking: booking ?? this.booking,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class CheckoutPaymobReadyState extends CheckoutState {
  final String paymentUrl;
  final BookingEntity booking;

  const CheckoutPaymobReadyState({
    required this.paymentUrl,
    required this.booking,
  });
}

class CheckoutSuccessState extends CheckoutState {
  final BookingEntity confirmedBooking;

  const CheckoutSuccessState(this.confirmedBooking);
}

class CheckoutErrorState extends CheckoutState {
  final String errorMessage;

  const CheckoutErrorState(this.errorMessage);
}
