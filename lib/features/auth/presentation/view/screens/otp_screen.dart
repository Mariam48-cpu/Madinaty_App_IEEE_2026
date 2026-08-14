import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/auth_cubit.dart';
import '../../view_model/auth_intent.dart';
import '../../view_model/auth_state.dart';
import '../widgets/custom_auth_button.dart';

class OTPScreen extends StatefulWidget {
  final String? phoneNumber;

  const OTPScreen({super.key, this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  static const int _otpLength = 6;
  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  int _resendCountdown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _resendCountdown = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _onVerifyPressed() {
    if (_otpCode.length == _otpLength) {
      context.read<AuthCubit>().processIntent(VerifyOtpIntent(_otpCode));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى إدخال الرمز كاملاً ($_otpLength أرقام)'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
    }
  }

  void _onResendOtp() {
    if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) {
      context.read<AuthCubit>().processIntent(
        SendOtpIntent(widget.phoneNumber!),
      );
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red.shade700,
            ),
          );
        } else if (state is AuthSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('مرحباً بك ${state.user.name ?? ""}'),
              backgroundColor: Colors.green.shade700,
            ),
          );
          // TODO: Navigate to Home Screen
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F6F0),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBE3D8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      size: 32,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'تأكيد رقم الموبايل',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty
                        ? 'أدخل الكود المرسل إلى ${widget.phoneNumber}'
                        : 'أدخل الكود المرسل إلى رقمك.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_otpLength, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 45,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBE3D8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < _otpLength - 1) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            if (_otpCode.length == _otpLength) {
                              _onVerifyPressed();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  if (_resendCountdown > 0)
                    Text(
                      'إعادة إرسال الكود خلال 00:${_resendCountdown.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  else
                    TextButton(
                      onPressed: isLoading ? null : _onResendOtp,
                      child: const Text(
                        'إعادة إرسال الكود',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),

                  const Spacer(),

                  CustomAuthButton(
                    text: 'تأكيد',
                    isLoading: isLoading,
                    onPressed: _onVerifyPressed,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
