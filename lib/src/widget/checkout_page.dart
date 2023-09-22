import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../paymaya_flutter.dart';
import '../models/payment_status/payment_status.dart';

class PaymayaCheckoutPage extends StatelessWidget {
  const PaymayaCheckoutPage({
    required this.url,
    required this.redirectUrls,
  });

  final String url;
  final PaymayaRedirectUrls redirectUrls;

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await canLaunchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

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
                    Navigator.pop(context, true);
                  },
                ),
                ElevatedButton(
                  child: const Text('CONTINUE'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ],
            );
          },
        );
        if (result ?? false) {
          Navigator.pop(
            context,
            PaymentStatus.cancel,
          );
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Web Page'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              _launchURL(url);
            },
            child: const Text('Open URL in Browser'),
          ),
        ),
      ),
    );
  }
}
