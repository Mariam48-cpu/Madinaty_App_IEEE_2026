import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/widgets/skeletons/payment_skeleton.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../booking/domain/entities/booking_entity.dart';

class PaymobWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final BookingEntity booking;

  const PaymobWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.booking,
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
            debugPrint('PAYMOB PAGE STARTED: $url');
            _checkTransactionStatus(url);
          },

          onPageFinished: (String url) {
            debugPrint('PAYMOB PAGE FINISHED: $url');

            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }

            _checkTransactionStatus(url);
          },

          onNavigationRequest: (NavigationRequest request) {
            debugPrint('PAYMOB NAVIGATION: ${request.url}');

            _checkTransactionStatus(request.url);

            /*
             * مهم:
             * لا نوقف أي navigation.
             * Paymob محتاج يكمل الـ flow الطبيعي بتاعه.
             */
            return NavigationDecision.navigate;
          },

          onWebResourceError: (WebResourceError error) {
            debugPrint(
              'PAYMOB WEBVIEW ERROR: '
              '${error.errorCode} - ${error.description}',
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _checkTransactionStatus(String url) {
    if (_isHandled) return;

    debugPrint('PAYMOB STATUS CHECK: $url');

    Uri uri;

    try {
      uri = Uri.parse(url);
    } catch (_) {
      return;
    }

    final query = uri.queryParameters;

    final successValue = query['success']?.trim().toLowerCase();

    final transactionResponse = query['txn_response_code']
        ?.trim()
        .toUpperCase();

    final message = (query['message'] ?? query['data.message'] ?? '')
        .trim()
        .toLowerCase();

    /*
     * ============================================================
     * SUCCESS
     * ============================================================
     *
     * لازم يكون فيه دليل صريح جدًا على نجاح العملية.
     *
     * مجرد:
     * - callback
     * - post_pay
     * - acceptance
     * - رجوع من Paymob
     *
     * لا يعني أن الدفع نجح.
     */
    final isExplicitSuccess =
        successValue == 'true' ||
        transactionResponse == 'APPROVED' ||
        message == 'approved' ||
        message.contains('transaction approved') ||
        message.contains('payment approved');

    /*
     * ============================================================
     * FAILURE
     * ============================================================
     */
    final isExplicitFailure =
        successValue == 'false' ||
        transactionResponse == 'DECLINED' ||
        transactionResponse == 'FAILED' ||
        transactionResponse == 'CANCELLED' ||
        transactionResponse == 'CANCELED' ||
        message == 'declined' ||
        message == 'failed' ||
        message == 'rejected' ||
        message == 'cancelled' ||
        message == 'canceled' ||
        message.contains('transaction declined') ||
        message.contains('payment failed');

    if (isExplicitFailure) {
      debugPrint('PAYMOB RESULT: FAILED');

      _handleFailure();
      return;
    }

    if (isExplicitSuccess) {
      debugPrint('PAYMOB RESULT: SUCCESS');

      _handleSuccess();
      return;
    }

    /*
     * أي URL آخر:
     *
     * لا نعمل أي حاجة.
     *
     * مهم جدًا إننا ما نقولش success لمجرد إننا وصلنا
     * إلى callback URL.
     */
  }

  void _handleSuccess() {
    if (_isHandled) return;

    _isHandled = true;

    debugPrint('PAYMOB WEBVIEW: returning TRUE');

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  void _handleFailure() {
    if (_isHandled) return;

    _isHandled = true;

    debugPrint('PAYMOB WEBVIEW: returning FALSE');

    if (!mounted) return;

    Navigator.of(context).pop(false);
  }

  Future<bool> _handleBackPressed() async {
    /*
     * لو المستخدم ضغط Back:
     *
     * لا نعتبر الدفع ناجح.
     * نرجع false للـ CheckoutScreen.
     */
    if (_isHandled) {
      return true;
    }

    _isHandled = true;

    debugPrint('PAYMOB WEBVIEW: USER CANCELLED / BACK');

    if (mounted) {
      Navigator.of(context).pop(false);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        await _handleBackPressed();
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          title: const Text('بوابة الدفع الآمن'),
          centerTitle: true,

          /*
           * زر الرجوع في الـ AppBar لازم يتعامل كـ cancel
           * وليس success.
           */
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackPressed,
          ),
        ),

        body: Stack(
          children: [
            WebViewWidget(controller: _controller),

            if (_isLoading)
              const Positioned.fill(child: PaymentWebViewSkeleton()),
          ],
        ),
      ),
    );
  }
}
