import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
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
        "intiating payment with amount - $amount \n qrCodeId - $qrCodeId \n redirectUrl - $redirectUrl \n currency -  $currency");
    initiatePayment();
  }

  void showAlertDialog(String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [continueButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    Apiss().purchaseQr(qrCodeId, amount, response.paymentId, redirectUrl);
    showAlertDialog("Payment Successful", "Payment ID: ${response.paymentId}");
  }

  fetchOrderId() async {
    print("Fetching order id");
    try {
      final orderId = await Apiss().createOrder(amount, currency);
      return orderId;
    } catch (e) {
      print("Error fetching orderId: $e");
      // Handle error scenario if needed
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
      showAlertDialog("Error", "Failed to create order. Please try again.");
    }
  }
}
