import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/paypal_config.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../utils/app_utils.dart';

class PayPalScreen extends StatefulWidget {
  final double totalAmount;
  final UserResponse currentUser;

  const PayPalScreen({
    super.key,
    required this.totalAmount,
    required this.currentUser,
  });

  @override
  PayPalScreenState createState() => PayPalScreenState();
}

class PayPalScreenState extends State<PayPalScreen> {
  bool isLoading = true;
  late final double _totalAmount;
  final PaymentService _paymentService = PaymentService();
  final PayPalService _paypalService = PayPalService();

  @override
  void initState() {
    super.initState();
    _totalAmount = widget.totalAmount;
    _clearPayPalCookies();
    _startPaymentProcess();
  }

  Future<void> _clearPayPalCookies() async {
    await WebViewCookieManager().clearCookies();
  }

  Future<void> _startPaymentProcess() async {
    try {
      final accessToken = await _paypalService.getAccessToken();
      final orderUrl = await _paypalService.createOrder(
        accessToken,
        _totalAmount,
      );
      _redirectToPayPal(orderUrl);
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(
          context,
          'Greška prilikom pokretanja plaćanja',
        );
        Navigator.of(context).pop();
      }
    }
  }

  void _redirectToPayPal(String approvalUrl) {
    final webviewController = _createWebViewController(approvalUrl);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('PayPal Plaćanje'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
            ),
            body: WebViewWidget(controller: webviewController),
          );
        },
      ),
    );
  }

  WebViewController _createWebViewController(String approvalUrl) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.startsWith(PayPalConfig.successUrl)) {
              _handlePaymentSuccess(url);
            }

            if (url.startsWith(PayPalConfig.cancelUrl)) {
              _handlePaymentCancel();
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(approvalUrl));
  }

  Future<void> _handlePaymentSuccess(String url) async {
    try {
      final paymentId =
          _paypalService.extractPaymentIdFromUrl(url) ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final paymentRequest = CreatePaymentRequest(
        amount: _totalAmount,
        status: PayPalConfig.statusCompleted,
        paymentMethod: PayPalConfig.paymentMethodPayPal,
        transactionId: paymentId,
        userId: widget.currentUser.id,
      );
      final result = await _paymentService.createPayment(paymentRequest);

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        if (result.status == PayPalConfig.statusCompleted) {
          AppUtils.showSuccessSnackbar(
            context,
            'Plaćanje je uspješno završeno!',
          );
        } else {
          AppUtils.showErrorSnackBar(
            context,
            'Greška prilikom obrade plaćanja.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        AppUtils.showSuccessSnackbar(context, 'Plaćanje je uspješno završeno!');
      }
    }
  }

  void _handlePaymentCancel() {
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      AppUtils.showSnackBar(
        context,
        'Plaćanje je otkazano',
        backgroundColor: Colors.orange,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Priprema plaćanja'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          Center(
            child: (!isLoading)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.payment, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Priprema PayPal plaćanja...',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Nazad"),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
