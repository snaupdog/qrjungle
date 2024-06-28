import 'package:flutter/material.dart';
import 'package:qrjungle/pages/qrcardgrid.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Container(
      //   margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      //   child: Padding(
      //     padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      body: Container(
        margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Wishlist',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Qrcardgrid(type: "wishlist", categoryName: ""),
            ],
          ),
        ),
      ),

      //         ],
      //       ),
      //     ),
      //   ),
      // );
    );
  }
}
