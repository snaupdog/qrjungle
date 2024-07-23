import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/moreqr/loader.dart';
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
    required String redirectUrl,
    this.currency = "INR",
  }) : redirectUrl = redirectUrl.startsWith('https://')
            ? redirectUrl
            : 'https://$redirectUrl' {
    print(
        "initiating payment with amount - $amount \n qrCodeId - $qrCodeId \n redirectUrl - $redirectUrl \n currency -  $currency");
    // initiatePayment();
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => Loader(qrId: qrCodeId, urlText: redirectUrl)),
      (route) => false,
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    await Apiss().purchaseQr(qrCodeId, amount, response.paymentId, redirectUrl);
    Apiss().listmyqrs();
    print('RESSSSSSSSSPOSNSEEEEEEEE : $response');
  }

  String email = "";
  getuserDetails() async {
    if (email == "") {
      email = Apiss.userdetailslist[0]['user_name'];
    }
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
      'key': 'rzp_live_E4Wv12VZpnQzUa',
      'amount': amount,
      'name': 'QrJungle',
      'description': 'Purchase QR Code',
      'image':
          'https://qrjungle-all-qrcodes.s3.ap-south-1.amazonaws.com/razorpaylogo.png',
      'order_id': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'email': email},
      'theme': {'color': '#000000'},
    };

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.open(options);
  }

  void initiatePayment() async {
    String? orderId = await fetchOrderId();
    if (orderId != null) {
      startPayment(orderId);
    } else {}
  }
}
