import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qrjungle/main.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/qrcardgrid.dart';
import 'package:rive/rive.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

bool redeemableloader = false;
bool showAnimation = false;

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    print(redeemable.value);
  }

  @override
  Widget build(BuildContext context) {
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

      await Future.delayed(const Duration(seconds: 5));

      setState(() {
        redeemableloader = false;
      });

      // Hide the animation after a few seconds
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
                child: Column(
                  children: [
                    (!loggedinmain)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.3),
                                Image.asset('assets/empty.png', height: 150),
                                const SizedBox(height: 15),
                                const Text('Not Logged In :(',
                                    style: TextStyle(fontSize: 26)),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0.0),
                                  child: Qrcardgrid(
                                      type: "wishlist", categoryName: ""),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.5, 0, 8.5, 00),
                                child: InkWell(
                                  onTap: () async {
                                    if (redeemable.value >=
                                        Apiss.myfavslist.length) {
                                      redeemllqr();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Unable to redeem'),
                                            content: Text(
                                                'you have to remove ${Apiss.myfavslist.length - redeemable.value} qrs from cart'),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff2081e2),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Redeem all QR\'s',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
          if (redeemableloader)
            Container(
              color: Colors.black,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitRipple(color: Colors.white),
                  Text(
                    "Confirming Purchase",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          if (showAnimation)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: RiveAnimation.asset('assets/done.riv'),
              ),
            ),
        ],
      ),
    );
  }
}
