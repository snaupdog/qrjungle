import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const List<String> _productIds = <String>[
  'artistic_qrs',
];

class StoreIos extends StatefulWidget {
  final String amount;
  final String imageurl;
  final String qrCodeId;
  final String redirectUrl;
  final String currency;

  StoreIos({
    super.key,
    required this.amount,
    required this.imageurl,
    required this.qrCodeId,
    required this.redirectUrl,
    this.currency = "INR",
  });

  @override
  State<StoreIos> createState() => _StoreIosState();
}

class _StoreIosState extends State<StoreIos> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  String? _notice;
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
    });

    if (!_isAvailable) {
      setState(() {
        _notice = "There are no upgrades at this time";
      });
      return;
    }

    // get IAP.
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_productIds.toSet());

    setState(() {
      _products = productDetailsResponse.productDetails;
    });

    if (productDetailsResponse.error != null) {
      setState(() {
        _notice = "There was a problem connecting to the store";
        print(_notice);
      });
    } else if (productDetailsResponse.productDetails.isEmpty) {
      setState(() {
        _notice = "There are no upgrades at this time";
        print(_notice);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Checkout",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                _products[0].title,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _products[0].price,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _products[0].description,
                style: const TextStyle(color: Colors.white),
              ),
              Text(widget.qrCodeId),
              Text(widget.redirectUrl),
              CachedNetworkImage(imageUrl: widget.imageurl),
              ElevatedButton(
                  onPressed: () {
                    final PurchaseParam purchaseParam =
                        PurchaseParam(productDetails: _products[0]);
                    InAppPurchase.instance
                        .buyConsumable(purchaseParam: purchaseParam);
                  },
                  child: const Text("buuy"))
            ],
          ),
        ));
  }
}
