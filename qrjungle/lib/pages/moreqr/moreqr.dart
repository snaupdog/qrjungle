// ignore_for_file: unused_field
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:qrjungle/pages/bottomnavbar/profile.dart';
import 'package:qrjungle/pages/moreqr/payment.dart';
import 'package:qrjungle/pages/moreqr/test.dart';
import 'package:qrjungle/pages/moreqr/widgets/modals.dart';
import 'package:qrjungle/pageselect.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

RxBool paymentloading = false.obs;
bool paymentloadingandroid = false;
RxBool gotoqrs = false.obs;

const List<String> _productIds = <String>[
  'artistic_qr',
];

class MoreQr extends StatefulWidget {
  final String imageUrl;
  final dynamic item;

  const MoreQr({
    Key? key,
    required this.imageUrl,
    required this.item,
  }) : super(key: key);

  @override
  State<MoreQr> createState() => _MoreQrState();
}

class _MoreQrState extends State<MoreQr> {
  final PaymentController paymentController = Get.put(PaymentController());
  Map<String, dynamic> fakedata = {
    "qr_code_status": "fake",
    "qr_code_created_on": 1714738115822,
    "qr_code_image_url_key": "2Omp.png",
    "qr_code_id": "fake",
    "qr_prompt": "fake",
    "price": null
  };
  Color? mostProminentColor;
  final TextEditingController urlcontroller = TextEditingController();
  bool isloading = true;
  bool liked = false;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  String? _notice;
  List<ProductDetails> _products = [];
  bool _loading = true;

  @override
  void initState() {
    print(widget.item);
    getloginstatus();
    super.initState();
    fetchMostProminentColor();
    if (Platform.isIOS) {
      initStoreInfo();
      paymentController.paymentLoading.listen((value) {
        try {
          if (!value) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const PageSelect(
                  initialIndex: 1,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          }
        } catch (e) {
          print('Navigation error: $e');
        }
      });
    }
  }

  paymentprocess(Payment pay) async {
    String? orderId = await pay.fetchOrderId();
    print(orderId);

    if (orderId != null) {
      pay.startPayment(orderId);

      setState(() {
        paymentloadingandroid = false;
      });
    } else {
      pay.navigateToResultPage(
          "Error", "Failed to create order. Please try again.");

      setState(() {
        paymentloadingandroid = false;
      });
    }
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
    });

    if (!_isAvailable) {
      setState(() {
        _loading = false;
        _notice = "There are no upgrades at this time";
      });
      return;
    }

    // get IAP.
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_productIds.toSet());

    setState(() {
      _loading = false;
      _products = productDetailsResponse.productDetails;
    });

    if (productDetailsResponse.error != null) {
      setState(() {
        _notice = "There was a problem connecting to the store";
      });
    } else if (productDetailsResponse.productDetails.isEmpty) {
      setState(() {
        _notice = "There are no upgrades at this time";
      });
    }
  }

  Future<Color> getMostProminentColor(String imageUrl) async {
    // Get the DefaultCacheManager

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
    print("looped  $a");

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

  getloginstatus() async {
    print('******* LOGINSTATUS CALLED *********8');
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool loggedin = pref.getBool('loggedin') ?? false;
    print("loggedin from sp: $loggedin");
    setState(() {
      loggedinmain = loggedin;
    });
  }

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
                      SizedBox(width: MediaQuery.sizeOf(context).width * 0.68),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: isloading
                ? const BoxDecoration(color: Colors.black)
                : BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.9, 1.0],
                      colors: [
                        Colors.black38,
                        mostProminentColor!.withOpacity(0.9),
                        mostProminentColor!,
                      ],
                    ),
                  ),
            child: Stack(
              children: [
                isloading
                    ? card(fakedata, "")
                    : card(widget.item, widget.imageUrl),
                Obx(
                  () {
                    if (paymentloading.value) {
                      return Container(
                        color: Colors.black.withOpacity(0.8),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitRipple(color: Colors.white),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Confirming Purchase",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Skeletonizer card(dynamic item, String imageUrl) {
    print(item);

    return Skeletonizer(
      enabled: isloading,
      enableSwitchAnimation: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
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
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 17.0, vertical: 0.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.135,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17.0, vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  children: item['qr_code_title']
                                      .toString()
                                      .split(' ')
                                      .asMap()
                                      .entries
                                      .map(
                                    (entry) {
                                      if (entry.key % 2 == 0) {
                                        return TextSpan(
                                            text: '${entry.value} ');
                                      } else {
                                        return TextSpan(
                                            text: '${entry.value}\n');
                                      }
                                    },
                                  ).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13, 0, 0, 0),
                                child: Text(
                                  "#${item['qr_code_id']}",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  // "${item['price']} INR",
                                  "799 INR",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "${item['qr_code_description']}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                              ),

                              maxLines: 4, // Maximum number of lines
                              overflow: TextOverflow
                                  .ellipsis, // Add ellipsis at the end if text overflows
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
          // const Divider(
          //   color: Color(0xff121212),
          // ),
          Skeleton.shade(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
              child: TextFormField(
                controller: urlcontroller,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Enter Link',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
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
          ),
          const SizedBox(height: 5.0),
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
                'QR code link can be changed after purchase.',
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
                const EdgeInsets.symmetric(horizontal: 17.0, vertical: 0.0),
            child: InkWell(
              onTap: () async {
                if (loggedinmain) {
                  print("Hello");
                  if (urlcontroller.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Redirect URL cannot be empty!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromARGB(134, 0, 0, 0),
                      textColor: Colors.white,
                      fontSize: 18.0,
                    );
                  } else {
                    Apiss.qr_idpayment = widget.item['qr_code_id'];
                    Apiss.qr_redirecturl = urlcontroller.text;
                    if (Platform.isIOS) {
                      setState(
                        () {
                          paymentloading.value = true;
                        },
                      );
                      final PurchaseParam purchaseParam =
                          PurchaseParam(productDetails: _products[0]);
                      _inAppPurchase.buyConsumable(
                          purchaseParam: purchaseParam);
                    } else if (Platform.isAndroid) {
                      Payment pay = Payment(
                        context: context,
                        // hardcoded price
                        amount: "${item['price']}00",
                        qrCodeId: item['qr_code_id'],
                        redirectUrl: urlcontroller.text,
                      );
                      paymentprocess(pay);
                    }
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
          Container(
            color: Colors.transparent,
            height: 900,
          )
        ],
      ),
    );
  }
}
