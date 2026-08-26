import 'dart:async';
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
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
    _startStatusPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startStatusPolling() {
    _pollingTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) async {
      if (_isHandled || !mounted) {
        timer.cancel();
        return;
      }
      try {
        final currentUrl = await _controller.currentUrl();
        if (currentUrl != null) {
          _checkTransactionStatus(currentUrl);
        }

        // فحص الـ DOM الداخلي للمحفظة في بيئة الاختبار
        final pageContent = await _controller
            .runJavaScriptReturningResult("document.body.innerText");
        final contentStr = pageContent.toString().toLowerCase();

        if (contentStr.contains('approved') ||
            contentStr.contains('successful') ||
            contentStr.contains('success') ||
            contentStr.contains('تمت العملية') ||
            contentStr.contains('تم الدفع بنجاح') ||
            contentStr.contains('transaction successful')) {
          _handleSuccess();
        } else if (contentStr.contains('declined') ||
            contentStr.contains('failed') ||
            contentStr.contains('فشلت') ||
            contentStr.contains('rejected')) {
          _handleFailure();
        }
      } catch (_) {}
    });
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _checkTransactionStatus(url);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
            _checkTransactionStatus(url);
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
    debugPrint('PAYMOB URL CHECK: $url');

    final uri = Uri.parse(url);
    final query = uri.queryParameters;

    final isCallbackHit = url.contains('madinaty-app.web.app') ||
        url.contains('post_pay') ||
        url.contains('acceptance/post_pay');

    final isExplicitSuccess = url.contains('success=true') ||
        query['success'] == 'true' ||
        url.contains('txn_response_code=APPROVED') ||
        (query['data.message']?.toLowerCase().contains('approved') ?? false) ||
        (query['message']?.toLowerCase().contains('approved') ?? false);

    final isFailed = url.contains('success=false') ||
        query['success'] == 'false' ||
        url.contains('txn_response_code=DECLINED') ||
        (query['data.message']?.toLowerCase().contains('declined') ?? false);

    if (isExplicitSuccess || (isCallbackHit && !isFailed)) {
      _handleSuccess();
    } else if (isFailed) {
      _handleFailure();
    }
  }

  void _handleSuccess() {
    if (_isHandled) return;
    _isHandled = true;
    _pollingTimer?.cancel();

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _handleFailure() {
    if (_isHandled) return;
    _isHandled = true;
    _pollingTimer?.cancel();

    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('بوابة الدفع الآمن'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Positioned.fill(child: PaymentWebViewSkeleton()),
        ],
      ),
    );
  }
}