import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:skeletonizer/skeletonizer.dart';

class VierMyQr extends StatefulWidget {
  final String imageUrl;
  final dynamic item;

  const VierMyQr({Key? key, required this.imageUrl, required this.item})
      : super(key: key);

  @override
  State<VierMyQr> createState() => _VierMyQrState();
}

class _VierMyQrState extends State<VierMyQr> {
  Map<String, dynamic> fakedata = {
    "qr_code_status": "fake",
    "qr_code_created_on": 1714738115822,
    "qr_code_image_url_key": "2Omp.png",
    "qr_code_category": "fake",
    "qr_code_id": "fake",
    "qr_prompt": "fake",
    "price": null
  };
  late String label;
  final TextEditingController urlcontroller = TextEditingController();
  bool isloading = true;
  Color? mostProminentColor;

  @override
  void initState() {
    label = widget.item['redirect_url'];
    super.initState();
    fetchMostProminentColor();
  }

  Future<Color> getMostProminentColor(String imageUrl) async {
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.getFileFromCache(imageUrl);
    Uint8List bytes;

    if (fileInfo != null) {
      bytes = await fileInfo.file.readAsBytes();
    } else {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to load image');
      }
      bytes = response.bodyBytes;
    }

    var a = 0;
    final image = img.decodeImage(Uint8List.fromList(bytes));
    if (image == null) throw Exception('Image cannot be decoded');

    Stopwatch colortime = Stopwatch()..start();
    final Map<int, int> colorCount = {};
    for (var y = 0; y < 10; y = y + 1) {
      for (var x = 0; x < image.width; x = x + 1) {
        a = a + 1;

        final pixel = image.getPixel(x, y);
        final color = ((pixel.a.toInt() & 0xFF) << 24) |
            ((pixel.r.toInt() & 0xFF) << 16) |
            ((pixel.g.toInt() & 0xFF) << 8) |
            (pixel.b.toInt() & 0xFF);
        colorCount[color] = (colorCount[color] ?? 0) + 1;
      }
    }
    print("looped $a");

    final mostProminentColor =
        colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    colortime.stop();
    print("this is time taken to fetch color ${colortime.elapsedMilliseconds}");
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

// Apiss().editRedirect("kHjF", "www.youtube.com");
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
                          onPressed: () async {
                            final urlImage = widget.imageUrl;
                            final sendimageurl = Uri.parse(urlImage);
                            final res = await http.get(sendimageurl);
                            final bytes = res.bodyBytes;
                            final temp = await getTemporaryDirectory();
                            final path = '${temp.path}/image.jpg';
                            File(path).writeAsBytesSync(bytes);
                            await Share.shareXFiles([XFile(path)],
                                text:
                                    'Check out this cool QR from QRJungle!\nDownload QRJungle now!');
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: isloading
                ? card(fakedata, "")
                : card(widget.item, widget.imageUrl),
          ),
        ),
      ),
    );
  }

  Skeletonizer card(dynamic item, String imageUrl) {
    return Skeletonizer(
      enabled: isloading,
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
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
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
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 1),
                            child: Text(
                              item['qr_code_category'][0].toUpperCase() +
                                  item['qr_code_category'].substring(1),
                              style: const TextStyle(
                                color: Color(0xff2081e2),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
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
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                prefixText: "https://",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: "current url - $label",
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      15.0, // Set the desired font size for the label text
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
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 25.0, 17, 4.0),
            child: InkWell(
              onTap: () async {
                if (urlcontroller.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Redirect URL is empty!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                    textColor: Colors.white,
                    fontSize: 18.0,
                  );
                }
                await Apiss().editRedirect(
                    item['qr_code_id'], "https://${urlcontroller.text}");
                Fluttertoast.showToast(
                    msg: "Qr Code URL changed successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                    textColor: Colors.white,
                    fontSize: 16.0);
                setState(() {
                  label = urlcontroller.text;
                });
                FocusScope.of(context).unfocus();
                urlcontroller.clear();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  color: const Color(0xff2081e2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text(
                    'Update URL',
                    style: TextStyle(
                        fontSize: 18.0,
// fontWeight: FontWeight.bold,
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
