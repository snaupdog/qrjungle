import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const List<String> _productIds = <String>[
  'buy_qrcode',
];

class StoreIos extends StatefulWidget {
  const StoreIos({super.key});

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
      print(_products[1].title);
      print(_products[1].price);
      print(_products[1].description);
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
              Text(
                _products[1].title,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _products[1].price,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _products[1].description,
                style: const TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                  onPressed: () {
                    final PurchaseParam purchaseParam =
                        PurchaseParam(productDetails: _products[1]);
                    InAppPurchase.instance
                        .buyConsumable(purchaseParam: purchaseParam);
                  },
                  child: const Text("buuy"))
            ],
          ),
        ));
  }
}
