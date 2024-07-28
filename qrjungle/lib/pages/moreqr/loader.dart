import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/moreqr/payment.dart';
import 'package:qrjungle/pageselect.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rive/rive.dart';

class Loader extends StatefulWidget {
  final String qrId;
  final String urlText;
  const Loader({super.key, required this.qrId, required this.urlText});

  @override
  State<Loader> createState() => _LoaderState();
}

bool redeemableloader = true;
bool showAnimation = false;
bool paymentsuccess = false;

class _LoaderState extends State<Loader> {
  void handlePaymentErrorResponse(PaymentFailureResponse response) async {
    await Future.delayed(const Duration(seconds: 2));
    print("trueFailed");
    paymentsuccess = false;

    setState(
      () {
        redeemableloader = false;
        if (!paymentsuccess) {
          showAnimation = true;
          Future.delayed(
            const Duration(milliseconds: 1000),
            () {
              setState(
                () {
                  opacity = 1.0;
                },
              );
            },
          );
        } else {
          print("Payment failed");
        }
      },
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    await Apiss()
        .purchaseQr(widget.qrId, "49900", response.paymentId, widget.urlText);
    Apiss().listmyqrs();

    paymentsuccess = true;

    setState(
      () {
        redeemableloader = false;
        if (paymentsuccess) {
          showAnimation = true;
          Future.delayed(
            const Duration(milliseconds: 1000),
            () {
              setState(
                () {
                  opacity = 1.0;
                },
              );
            },
          );
        } else {
          print("Payment failed");
        }
      },
    );
  }

  void startPayment(String orderId) {
    print("initiating razorpay ");
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_live_E4Wv12VZpnQzUa',
      'amount': "49900",
      'name': 'QrJungle',
      'description': 'Purchase QR Code',
      'image':
          'https://qrjungle-all-qrcodes.s3.ap-south-1.amazonaws.com/razorpaylogo.png',
      'order_id': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'email': ""},
      'theme': {'color': '#000000'},
    };

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.open(options);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
  }

  androidpaymentprocess(Payment pay) async {
    String? orderId = await pay.fetchOrderId();
    print(orderId);

    if (orderId != null) {
      startPayment(orderId);
    } else {
      print("Order id creation failed");
    }
  }

  double opacity = 0.0;
  buyqr() async {
    if (Platform.isAndroid) {
      Payment pay = Payment(
        context: context,
        // hardcoded price
        amount: "79900",
        // amount: "${item['price']}00",
        qrCodeId: widget.qrId,
        redirectUrl: widget.urlText,
      );
      androidpaymentprocess(pay);
    }

    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    buyqr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (redeemableloader)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitRipple(
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    "Processing Payment",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          if (showAnimation)
            (paymentsuccess)
                ? AnimatedOpacity(
                    opacity: opacity,
                    duration: const Duration(seconds: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width:
                              300, // Adjust width and height as per your animation size
                          height: 300,
                          child: Center(
                            child: RiveAnimation.asset('assets/done.riv'),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Center(
                            child: Text("QR's Purchased successfully")),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PageSelect(
                                    initialIndex: 1,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text("View your new QRs"),
                          ),
                        ),
                      ],
                    ),
                  )
                : AnimatedOpacity(
                    opacity: opacity,
                    duration: const Duration(seconds: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 500, // Adjust width as needed
                          height: 500, // Adjust height as needed
                          child: Center(
                            child: RiveAnimation.asset('assets/error.riv'),
                          ),
                        ),
                        const SizedBox(
                            height: 10), // Increase or decrease as needed
                        const Center(
                          child: Text("Error in processing payment"),
                        ),
                        const SizedBox(
                            height: 16), // Increase or decrease as needed
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PageSelect(
                                    initialIndex: 1,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              "View your new QRs",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
        ],
      ),
    );
  }
}
