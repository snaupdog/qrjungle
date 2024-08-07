import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrjungle/main.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/bottomnavbar/loader.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/qrcardgrid.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                              height: MediaQuery.sizeOf(context).height * 0.3),
                          Image.asset('assets/empty.png', height: 150),
                          const SizedBox(height: 15),
                          const Text('Not Logged In :(',
                              style: TextStyle(fontSize: 26)),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              height: MediaQuery.sizeOf(context).height * 0.7,
                              child: const Qrcardgrid(
                                  type: "wishlist", categoryName: "")),
                          InkWell(
                            onTap: () async {
                              if (redeemable.value >= Apiss.myfavslist.length) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Loader()),
                                  (route) => false,
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Unable to redeem'),
                                      content: Text(
                                          'you have to remove ${Apiss.myfavslist.length - redeemable.value} qrs from cart'),
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: const Color(0xff2081e2),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Obx(
                                  () => Center(
                                    child: Text(
                                      'Redeem all QR\'s     ${redeemable.value} left',
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
