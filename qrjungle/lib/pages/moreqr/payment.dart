import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pageselect.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment {
  final String amount;
  final String qrCodeId;
  final String redirectUrl;
  final String currency;
  final BuildContext context;

  Payment({
    required this.context,
    required this.amount,
    required this.qrCodeId,
    required this.redirectUrl,
    this.currency = "INR",
  }) {
    print(
        "initiating payment with amount - $amount \n qrCodeId - $qrCodeId \n redirectUrl - $redirectUrl \n currency -  $currency");
    initiatePayment();
  }

  void navigateToResultPage(String title, String message,
      {bool success = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentResultPage(
          title: title,
          message: message,
          success: success,
          redirectUrl: redirectUrl,
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    navigateToResultPage(
      "Payment Failed",
      "Description: ${response.message}",
      success: false,
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    Apiss().purchaseQr(qrCodeId, amount, response.paymentId, redirectUrl);
    Apiss().listmyqrs();

    navigateToResultPage(
      "Payment Successful!",
      "Payment ID: ${response.paymentId}",
      success: true,
    );
  }

  Future<String?> fetchOrderId() async {
    print("Fetching order id");
    try {
      final orderId = await Apiss().createOrder(amount, currency);
      return orderId;
    } catch (e) {
      print("Error fetching orderId: $e");
      return null;
    }
  }

  void startPayment(String orderId) {
    print("initiating razorpay ");
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_fn7n6bC23PIxXQ',
      'amount': amount,
      'name': 'Qr jungle',
      'description': 'Purchasing QR code',
      'order_id': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'theme': {'color': '#8354E2'},
    };

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.open(options);
  }

  void initiatePayment() async {
    String? orderId = await fetchOrderId();
    if (orderId != null) {
      startPayment(orderId);
    } else {
      navigateToResultPage(
          "Error", "Failed to create order. Please try again.");
    }
  }
}

class PaymentResultPage extends StatelessWidget {
  final String title;
  final String message;
  final bool success;
  final String redirectUrl;

  PaymentResultPage({
    required this.title,
    required this.message,
    required this.success,
    required this.redirectUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            success
                ? PaymentSuccessActions(redirectUrl: redirectUrl)
                : Container(),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessActions extends StatelessWidget {
  final String redirectUrl;

  PaymentSuccessActions({required this.redirectUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageSelect(initialIndex: 0)));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            child: Text(
              'Browse More QRs',
              style: TextStyle(
                  fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageSelect(initialIndex: 1)));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            child: Text(
              'View Your QRs',
              style: TextStyle(
                  fontSize: 16.0, color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ),
      ],
    );
  }
}
