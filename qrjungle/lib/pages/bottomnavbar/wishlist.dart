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
    return const SingleChildScrollView(
        child: Qrcardgrid(type: "wishlist", categoryName: ""));
  }
}
