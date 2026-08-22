import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../core/utils/app_toast.dart';
import '../../../../booking/domain/entities/booking_entity.dart';

class PaymobWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final BookingEntity booking;
  final Function(BookingEntity confirmedBooking) onPaymentSuccess;

  const PaymobWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.booking,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymobWebViewScreen> createState() => _PaymobWebViewScreenState();
}

class _PaymobWebViewScreenState extends State<PaymobWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isHandled = false;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
            _checkTransactionStatus(url);
          },
          onPageFinished: (String url) async {
            if (mounted) setState(() => _isLoading = false);
            _checkTransactionStatus(url);

            if (!_isHandled) {
              try {
                final pageContent = await _controller
                    .runJavaScriptReturningResult("document.body.innerText");
                final contentStr = pageContent.toString().toLowerCase();
                if (contentStr.contains('approved') ||
                    contentStr.contains('successful') ||
                    contentStr.contains('success')) {
                  _handleSuccess();
                }
              } catch (_) {}
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            _checkTransactionStatus(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _checkTransactionStatus(String url) {
    if (_isHandled) return;
    debugPrint('CURRENT PAYMOB URL: $url');

    final uri = Uri.parse(url);
    final query = uri.queryParameters;

    final isExplicitSuccess =
        url.contains('success=true') ||
        query['success'] == 'true' ||
        url.contains('txn_response_code=APPROVED') ||
        (query['data.message']?.toLowerCase().contains('approved') ?? false) ||
        (query['message']?.toLowerCase().contains('approved') ?? false);

    final isCallbackSuccess =
        (url.contains('post_pay') || url.contains('acceptance/post_pay')) &&
        !url.contains('success=false');

    final isFailed =
        url.contains('success=false') ||
        query['success'] == 'false' ||
        url.contains('txn_response_code=DECLINED') ||
        (query['data.message']?.toLowerCase().contains('declined') ?? false);

    if (isExplicitSuccess || isCallbackSuccess) {
      _handleSuccess();
    } else if (isFailed) {
      _handleFailure();
    }
  }

  void _handleSuccess() {
    if (_isHandled) return;
    if (mounted) {
      Navigator.of(context).pop();
      widget.onPaymentSuccess(widget.booking);
    }
    _isHandled = true;
  }

  void _handleFailure() {
    if (_isHandled) return;
    _isHandled = true;

    if (mounted) {
      Navigator.of(context).pop();
      AppToast.showToast(
        context: context,
        title: 'فشلت عملية الدفع',
        description: 'يرجى المحاولة مرة أخرى أو اختيار طريقة دفع أخرى',
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('بوابة الدفع الآمن'), centerTitle: true),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
