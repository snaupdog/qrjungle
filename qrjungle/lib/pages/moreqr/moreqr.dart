import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:qrjungle/pages/moreqr/payment.dart';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/moreqr/widgets/modals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  Map<String, dynamic> fakedata = {
    "qr_code_status": "fake",
    "qr_code_created_on": 1714738115822,
    "qr_code_image_url_key": "2Omp.png",
    "qr_code_category": "fake",
    "qr_code_id": "fake",
    "qr_prompt": "fake",
    "price": null
  };
  Color? mostProminentColor;

  @override
  void initState() {
    super.initState();
    if (loggedinmain) {
      Apiss().listFavourites();
    }
    fetchMostProminentColor();
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

  Future<void> fetchMostProminentColor() async {
    try {
      final color = await getMostProminentColor(widget.imageUrl);
      setState(() {
        mostProminentColor = color;
        isloading = false;
      });
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print('Error: $e');
    }
  }

  getloginstatus() async {
    print('******* LOGINSTATUS CALLED *********8');
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool loggedin = pref.getBool('loggedin') ?? false;
    print("loggedin from sp: $loggedin");
    setState(() {
      loggedinmain = loggedin;
    });
  }

  Future<void> toggleFavourite() async {
    if (Apiss.favqrsids.contains(widget.item['qr_code_id'])) {
      Apiss.favqrsids.remove(widget.item['qr_code_id']);
      print("removed from wishlist");
    } else {
      Apiss.favqrsids.add(widget.item['qr_code_id']);
      print("added to wishlist");
    }
    await Apiss().addFavourites(Apiss.favqrsids);
    Apiss().listFavourites();
    print("Updated favourites");
  }

  final TextEditingController urlcontroller = TextEditingController();
  bool liked = false;
  bool isloading = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
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
        body: SingleChildScrollView(
          child: isloading
              ? card(fakedata, "")
              : card(widget.item, widget.imageUrl),
        ),
      ),
    );
  }

  Skeletonizer card(dynamic item, String imageUrl) {
    return Skeletonizer(
      enabled: isloading,
      enableSwitchAnimation: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                // Gradient background
                Container(
                  decoration: isloading
                      ? const BoxDecoration(color: Colors.black)
                      : BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: const [0.0, 0.2, 0.7, 1.0],
                            colors: [
                              Colors.black,
                              Colors.black,
                              mostProminentColor!.withOpacity(0.9),
                              mostProminentColor!,
                            ],
                          ),
                        ),
                ),
                // Image
                Padding(
                  padding: const EdgeInsets.fromLTRB(17.0, 70.0, 17.0, 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 17.0, vertical: 0.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 17.0, vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "#${item['qr_code_id']}",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              item['qr_code_category'],
                              style: const TextStyle(
                                color: const Color(0xff2081e2),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon:
                          Icon(liked ? Icons.favorite : Icons.favorite_border),
                      onPressed: () async {
                        if (loggedinmain) {
                          setState(() {
                            liked = !liked;
                          });
                          Fluttertoast.showToast(
                            msg: liked
                                ? "Added to Favourites!"
                                : "removed from Favourites",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                            textColor: Colors.white,
                            fontSize: 18.0,
                          );
                          await toggleFavourite();
                        } else {
                          print("show modal sheet");
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => const LoginModalSheet(),
                          );
                        }
                      },
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
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
                  fontSize: 12.0,
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
          const SizedBox(height: 5.0), // Adjust the spacing as needed
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(children: [
              Icon(
                Icons.info_outline,
                size: 16.0,
                color: Colors.grey,
              ),
              SizedBox(width: 5.0),
              Text(
                'Note: The redirect URL can be changed at any time.',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 17.0, vertical: 4.0),
            child: InkWell(
              onTap: () {
                if (loggedinmain) {
                  if (urlcontroller.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Redirect URL cannot be empty!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                      textColor: Colors.white,
                      fontSize: 18.0,
                    );
                  } else {
                    Payment(
                      context: context,
                      amount: "500",
                      qrCodeId: item['qr_code_id'],
                      redirectUrl: urlcontroller.text,
                    );
                  }
                } else {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const LoginModalSheet(),
                  );
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
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
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
