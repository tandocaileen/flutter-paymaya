import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../paymaya_flutter.dart';
import '../models/payment_status/payment_status.dart';

class PaymayaCheckoutPage extends StatefulWidget {
  ///{@macro checkoutpage}
  const PaymayaCheckoutPage({
    required this.url,
    required this.redirectUrls,
  });

  /// url used came from the successful url link
  final String url;

  /// redirect urls from the single payment
  final PaymayaRedirectUrls redirectUrls;
  @override
  _PaymayaCheckoutPageState createState() => _PaymayaCheckoutPageState();
}

class _PaymayaCheckoutPageState extends State<PaymayaCheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Do you want to cancel your order'),
                content: const Text(''),
                actions: [
                  TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('YES'),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  )
                ],
              );
            });
        if (result ?? false) {
          Navigator.pop(
            context,
            PaymentStatus.cancel,
          );
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: WebViewWidget(
            controller: WebViewController()
              ..loadRequest(Uri.parse(widget.url))
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..enableZoom(true)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onNavigationRequest: (NavigationRequest delegate) {
                    if (delegate.url.contains(widget.redirectUrls.success)) {
                      Navigator.pop(context, PaymentStatus.success);
                    } else if (delegate.url
                        .contains(widget.redirectUrls.failure)) {
                      Navigator.pop(context, PaymentStatus.failure);
                    } else if (delegate.url
                        .contains(widget.redirectUrls.cancel)) {
                      Navigator.pop(context, PaymentStatus.cancel);
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              ),
          ),
        ),
      ),
    );
  }
}
