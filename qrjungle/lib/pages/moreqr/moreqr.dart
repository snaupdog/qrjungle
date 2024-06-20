import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis.dart';
import 'package:qrjungle/pages/moreqr/widgets/popup_card.dart';

class MoreQr extends StatefulWidget {
  final String imageUrl;
  const MoreQr({super.key, required this.imageUrl});

  @override
  State<MoreQr> createState() => _MoreQrState();
}

class _MoreQrState extends State<MoreQr> {
  @override
  void initState() {
    super.initState();
    fetchUrls();
  }

  Future<void> fetchUrls() async {
    try {
      Apiss().getCategories();
      Apiss().getqrfromCategories("Food");
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(child: PopupCard(item: widget.imageUrl)),
        ],
      ),
    );
  }
}
