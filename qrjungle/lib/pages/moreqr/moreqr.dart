//Opens a new page with information about the QR code that has been tapped.

import 'package:flutter/material.dart';
import 'package:qrjungle/models/qr_info.dart';
import 'package:qrjungle/pages/moreqr/widgets/popup_card.dart';

import 'buy.dart';

import 'buy.dart';

class MoreQr extends StatefulWidget {
  final String imageUrl;
  final QrInfo qrinfo;
  const MoreQr({super.key, required this.imageUrl, required this.qrinfo});

  @override
  State<MoreQr> createState() => _MoreQrState();
}

class _MoreQrState extends State<MoreQr> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: PopupCard(imageUrl: widget.imageUrl),
          ), //Builds the page using PopUpCard widget in popup_card.dart file
          Text(widget.qrinfo.category),
          Text(widget.qrinfo.qr_code_id),
          widget.qrinfo.price != null
              ? Text(widget.qrinfo.price.toString())
              : const Text("Free"),

          Positioned(
            top: 20,
            right: 20,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Purchase(
                            amount: "500",
                            qr_code_id: widget.qrinfo.qr_code_id)),
                  );
                },
                child: const Text('Purchase this qrrs'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
