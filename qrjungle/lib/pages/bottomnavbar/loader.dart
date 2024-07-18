import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qrjungle/main.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pageselect.dart';
import 'package:rive/rive.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

bool redeemableloader = true;
bool showAnimation = false;

class _LoaderState extends State<Loader> {
  redeemllqr() async {
    setState(() {
      redeemableloader = true;
      showAnimation = false;
    });

    await Apiss().listFavourites();
    for (var item in Apiss.myfavslist) {
      print("created order for ${item['qr_code_id']}");
      // await Apiss()
      //     .purchaseQr(item['qr_code_id'], "499", "reedamable_purchase", "");
    }
    // Update redeemable
    redeemable.value = redeemable.value - Apiss.myfavslist.length;

    Apiss().updateRedeemables(redeemable.value.toString());

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      redeemableloader = false;
      showAnimation = true;
    });

    // Hide the animation after a few seconds
  }

  @override
  void initState() {
    super.initState();
    redeemllqr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff161616),
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
                    "Confirming Purchase",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          if (showAnimation)
            Column(
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
                const SizedBox(height: 20),
                const Center(child: Text("QR's  redeemed successfully")),
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
        ],
      ),
    );
  }
}
