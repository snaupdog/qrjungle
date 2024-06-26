import 'package:flutter/material.dart';
import 'package:qrjungle/models/qr_info.dart';
import 'package:qrjungle/pages/moreqr/widgets/popup_card.dart';

import 'buy.dart';

class MoreQr extends StatefulWidget {
  final String imageUrl;
  final QrInfo qrinfo;

  MoreQr({Key? key, required this.imageUrl, required this.qrinfo}) : super(key: key);

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
        leading:  Container(),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [    
              Container(
                margin: EdgeInsets.fromLTRB(7, 10, 7, 0),
                child: Row(
                  children: [
                    Container(                                           
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(175, 0, 0, 0)
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, size: 25),
                        onPressed: () {
                          Navigator.pop(context);
                          print("Notifications button pressed");
                        },
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width:MediaQuery.sizeOf(context).width*0.71),                                        
                    Container(
                      //margin: EdgeInsets.fromLTRB(8, 8, 8, 28), 
                    
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(175, 0, 0, 0)
                      ),
                      child: IconButton(
                        icon: Icon(Icons.share, size: 25),
                        
                        onPressed: () {
                          // Add your onPressed code here!
                          print("Share button pressed");
                        },
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width:MediaQuery.sizeOf(context).width*0.018),
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
          SizedBox(height: 16),
          Text(widget.qrinfo.category),
          Text(widget.qrinfo.qr_code_id),
          Text(widget.qrinfo.price != null ? widget.qrinfo.price.toString() : "Free"),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Purchase(
                    amount: "500",
                    qr_code_id: widget.qrinfo.qr_code_id,
                  ),
                ),
              );
            },
            child: const Text('Purchase this QR'),
          ),
        ],
      ),
    );
  }
}
