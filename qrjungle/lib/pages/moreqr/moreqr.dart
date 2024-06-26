import 'package:flutter/material.dart';
import 'package:qrjungle/pages/moreqr/payment.dart';
import 'package:qrjungle/pages/moreqr/widgets/popup_card.dart';

class MoreQr extends StatefulWidget {
  final String imageUrl;
  final dynamic item;

  const MoreQr({Key? key, required this.imageUrl, required this.item})
      : super(key: key);

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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(7, 10, 7, 0),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(175, 0, 0, 0)),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 25),
                        onPressed: () {
                          Navigator.pop(context);
                          print("Back Button");
                        },
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: MediaQuery.sizeOf(context).width * 0.71),
                    Container(
                      //margin: EdgeInsets.fromLTRB(8, 8, 8, 28),

                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(175, 0, 0, 0)),
                      child: IconButton(
                        icon: const Icon(Icons.share, size: 25),
                        onPressed: () {
                          // Add your onPressed code here!
                          print("Share button pressed");
                        },
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: MediaQuery.sizeOf(context).width * 0.018),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: PopupCard(imageUrl: widget.imageUrl),
          ), //Builds the page using PopUpCard widget in popup_card.dart file
          const SizedBox(height: 16),
          Text(widget.item['qr_code_id']),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Payment(
                  context: context,
                  amount: "500",
                  qrCodeId: widget.item['qr_code_id'],
                  redirectUrl: "www.google.com");
            },
            child: const Text('Purchase this QR'),
          ),
        ],
      ),
    );
  }
}
