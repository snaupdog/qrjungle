// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis_graph.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

//
// class Purchase extends StatelessWidget {
//   const Purchase({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
//
class Purchase extends StatefulWidget {
  final String amount;
  final String qr_code_id;
  final String redirect_url = "https://www.google.com/";
  final String currency = "INR";
  const Purchase({super.key, required this.amount, required this.qr_code_id});

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  @override
  void initState() {
    super.initState();
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
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

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    ApissGraph().purchaseQr(widget.qr_code_id, widget.amount,
        response.paymentId, widget.redirect_url);
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  fetchOrderId<String>() async {
    try {
      final orderId =
          await ApissGraph().createOrder(widget.amount, widget.currency);
      return orderId;
    } catch (e) {
      print("Error fetching orderId: $e");
      // Handle error scenario if needed
    }
  }

  Razorpay_Options(amount, orderID) {
    Razorpay razorpay = Razorpay();
    var options = {
      //fill options here

      'key': 'rzp_test_fn7n6bC23PIxXQ',
      'amount': amount,
      'name': 'Anyquire Credits',
      'description': 'Credits',

      'order_id': orderID,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      // 'prefill': {'contact': '${User.userPhonenumber}'},
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'theme': {'color': '#8354E2'},
      // 'image': 'assets/LaunchLogo-aq.png'

      // 'external': {
      //   'wallets': ['paytm']
      //             }
    };

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    razorpay.open(options);
  }

  String id = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Pay with Razorpay',
            ),
            ElevatedButton(
                onPressed: () {
                  print("hi");
                  id = fetchOrderId();
                },
                child: const Text("get order id")),
            ElevatedButton(
                onPressed: () {
                  Razorpay_Options(widget.amount, id);
                },
                child: const Text("Pay now "))
          ],
        ),
      ),
    );
  }
}
