import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
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
  List<String> favlist = [];

  @override
  void initState() {
    super.initState();
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    try {
      var response = await Apiss().listUserDetails();
      var data = response[0]['favourites'];
      setState(() {
        favlist = List<String>.from(data);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> toggleFavourite() async {
    await loadFavourites();
    if (favlist.contains(widget.item['qr_code_id'])) {
      favlist.remove(widget.item['qr_code_id']);
      print("removed from wishlist");
    } else {
      favlist.add(widget.item['qr_code_id']);
      print("added to wishlist");
    }
    await Apiss().addFavourites(favlist);
    print("Updated favourites");
  }

  final TextEditingController urlcontroller = TextEditingController();

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
                          print("Back button pressed");
                        },
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: MediaQuery.sizeOf(context).width * 0.71),
                    Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: PopupCard(imageUrl: widget.imageUrl),
          ),
          IconButton(
            icon: const Icon(Icons.pix, size: 25),
            onPressed: () async {
              await toggleFavourite();
            },
            color: Colors.white,
          ),
          Text(widget.item['qr_code_id']),
          TextFormField(
            controller: urlcontroller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter redirect URL',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Payment(
                context: context,
                amount: "500",
                qrCodeId: widget.item['qr_code_id'],
                redirectUrl: urlcontroller.text,
              );
            },
            child: const Text('Purchase this QR'),
          ),
        ],
      ),
    );
  }
}
