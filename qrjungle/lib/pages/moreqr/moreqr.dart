import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:qrjungle/pages/moreqr/payment.dart';

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
    print(widget.item);
  }

  Future<Color> getMostProminentColor(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load image');
    }

    final bytes = response.bodyBytes;
    final image = img.decodeImage(Uint8List.fromList(bytes));
    if (image == null) throw Exception('Image cannot be decoded');

    final Map<int, int> colorCount = {};
    for (var y = 0; y < 50; y = y + 1) {
      for (var x = 0; x < image.width; x = x + 1) {
        final pixel = image.getPixel(x, y);
        final color = ((pixel.a.toInt() & 0xFF) << 24) |
            ((pixel.r.toInt() & 0xFF) << 16) |
            ((pixel.g.toInt() & 0xFF) << 8) |
            (pixel.b.toInt() & 0xFF);
        colorCount[color] = (colorCount[color] ?? 0) + 1;
      }
    }

    final mostProminentColor =
        colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return Color(mostProminentColor);
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
    return SafeArea(
      child: Scaffold(
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<Color>(
              future: getMostProminentColor(widget.imageUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading gradient'));
                } else if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.2, 0.7, 1.0],
                        colors: [
                          Colors.black,
                          Colors.black,
                          snapshot.data!.withOpacity(0.9),
                          snapshot.data!,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 60.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 17.0, vertical: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                15.0), // Adjust the radius as needed
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No color found'));
                }
              },
            ),
            const SizedBox(
              height: 20.0,
            ),

            const Divider(
              color: Color(0xff121212),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
              child: TextFormField(
                controller: urlcontroller,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Enter Redirect URL',
                  labelStyle: const TextStyle(
                    fontSize:
                        12.0, // Set the desired font size for the label text
                  ),
                  fillColor: const Color(0xFF1b1b1b),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                cursorColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 20.0),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 17.0, vertical: 4.0),
              child: InkWell(
                onTap: () {
                  Payment(
                    context: context,
                    amount: "500",
                    qrCodeId: widget.item['qr_code_id'],
                    redirectUrl: urlcontroller.text,
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.05, // Adjust as needed
                  decoration: BoxDecoration(
                    color: const Color(0xff2081e2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Purchase QR',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // IconButton(
            //   icon: const Icon(Icons.favorite, size: 25),
            //   onPressed: () async {
            //     await toggleFavourite();
            //   },
            //   color: Colors.white,
            // ),
          ],
        ),
      ),
    );
  }
}
