import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pageselect.dart';
import 'package:qrjungle/themes.dart';
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
    showAlertDialog(context, "Payment Failed", "Code: ${response.message}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    await Apiss().purchaseQr(qrCodeId, amount, response.paymentId, redirectUrl);
    Apiss().listmyqrs();
    print('RESSSSSSSSSPOSNSEEEEEEEE : $response');
    navigateToResultPage(
      "Payment Successful!",
      "Payment ID: ${response.paymentId}",
      success: true,
    );
  }

  String email = "";
  getuserDetails() async {
    Apiss.myfavslist;
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

  const PaymentResultPage({
    super.key,
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
            Text('$title!', style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 40),
            Text(
              message,
              style: const TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            success
                ? PaymentSuccessActions(redirectUrl: redirectUrl)
                : Container(),
          ],
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context, String title, String message) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class PaymentSuccessActions extends StatelessWidget {
  final String redirectUrl;

  const PaymentSuccessActions({super.key, required this.redirectUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PageSelect(initialIndex: 0),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: accentcolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            child: Text(
              'Browse More QRs',
              style: TextStyle(
                  fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PageSelect(initialIndex: 1),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: accentcolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            child: Text(
              'View Your QRs',
              style: TextStyle(
                  fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ),
      ],
    );
  }
}
