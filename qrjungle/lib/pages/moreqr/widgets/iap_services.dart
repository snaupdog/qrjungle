import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qrjungle/models/apiss.dart';

class IAPService {
  final GlobalKey<NavigatorState> navigatorKey;

  IAPService(this.navigatorKey);
  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print("purchaseDetails.status ${purchaseDetails.status}");
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        _handleSuccessfulPurchase(purchaseDetails);
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        print(purchaseDetails.error!);
      }

      if (purchaseDetails.pendingCompletePurchase) {
        print("Complete purchase");
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        print("Purchase marked complete");
      }
    });
  }

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == 'artistic_qrs') {
      // await Apiss()
      //     .purchaseQr(Apiss.qr_idpayment, "399", "", "https://sniapdog.com");
      print("should successfully get order id");
      Apiss().listmyqrs();

      if (navigatorKey.currentState != null) {
        navigatorKey.currentState?.pushNamed('/myqrs');
      }
    }
  }
}
