import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:qrjungle/main.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pageselect.dart';
import 'package:rive/rive.dart';

class Loader extends StatefulWidget {
  final String? qrId;
  final String? urlText;
  const Loader({super.key, this.qrId, this.urlText});

  @override
  State<Loader> createState() => _LoaderState();
}

bool redeemableloader = true;
bool showAnimation = false;

class _LoaderState extends State<Loader> {
  double opacity = 0.0;
  redeemllqr() async {
    setState(() {
      redeemableloader = true;
      showAnimation = false;
    });
    if (widget.qrId == null) {
      await Apiss().listFavourites();
      for (var item in Apiss.myfavslist) {
        print("created order for ${item['qr_code_id']}");
        Apiss()
            .purchaseQr(item['qr_code_id'], "499", "reedamable_purchase", "");
      }
      Apiss.favqrsids = [];
      await Apiss().addFavourites(Apiss.favqrsids);
      Apiss().listFavourites();
      await Apiss().listmyqrs();
      // Update redeemable
      redeemable.value = redeemable.value - Apiss.myfavslist.length;
    } else {
      //hardcoded
      Apiss().purchaseQr(
          widget.qrId!, "499", "reedamable_purchase", widget.urlText!);
      print("Bought ${widget.qrId}");
    }

    Apiss().updateRedeemables(redeemable.value.toString());
    Apiss().listmyqrs();

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      redeemableloader = false;
      showAnimation = true;
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          opacity = 1.0;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    redeemllqr();
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
                    "Redeeming QRs",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          if (showAnimation)
            AnimatedOpacity(
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
                  const Center(child: Text("QR's redeemed successfully")),
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
            ),
        ],
      ),
    );
  }
}
