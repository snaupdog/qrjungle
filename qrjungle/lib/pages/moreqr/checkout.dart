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

  const StoreIos({
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
  bool _loading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _isAvailable && _products.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Checkout",
                        style: TextStyle(fontSize: 20, color: Colors.white),
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
                      Text(
                        widget.qrCodeId,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        widget.redirectUrl,
                        style: const TextStyle(color: Colors.white),
                      ),
                      CachedNetworkImage(imageUrl: widget.imageurl),
                      ElevatedButton(
                        onPressed: () {
                          final PurchaseParam purchaseParam =
                              PurchaseParam(productDetails: _products[0]);
                          _inAppPurchase.buyConsumable(
                              purchaseParam: purchaseParam);
                        },
                        child: const Text("Buy"),
                      ),
                    ],
                  )
                : Text(
                    _notice ?? "Loading...",
                    style: const TextStyle(color: Colors.white),
                  ),
      ),
    );
  }
}
