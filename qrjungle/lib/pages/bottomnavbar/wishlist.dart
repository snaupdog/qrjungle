import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/hi.dart';
import 'package:qrjungle/pages/qrcardgrid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    print("This is wishlist logged in check $loggedinmain");
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AnimatedGridSample(),
          ),
        );
      }),
      body: SingleChildScrollView(
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
                                height:
                                    MediaQuery.sizeOf(context).height * 0.3),
                            Image.asset('assets/empty.png', height: 150),
                            const SizedBox(height: 15),
                            const Text('Not Logged In :(',
                                style: TextStyle(fontSize: 26)),
                          ],
                        ),
                      )
                    : const Qrcardgrid(type: "wishlist", categoryName: ""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
