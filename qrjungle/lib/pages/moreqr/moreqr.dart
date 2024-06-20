//Opens a new page with information about the QR code that has been tapped.


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
    print("Asdfdasf11");
    try {
      print("Asdfasdf22");
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
          Center(child: PopupCard(item: widget.imageUrl)),  //Builds the page using PopUpCard widget in popup_card.dart file
        ],
      ),
    );
  }
}
