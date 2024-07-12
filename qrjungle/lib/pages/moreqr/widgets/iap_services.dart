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
        // paymentloading.value = false;
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState?.pushReplacementNamed('/Home');
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        print("Complete purchase");
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        print("Purchase marked complete");
        // paymentloading.value = false;
      }
    });
  }

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == 'artistic_qr') {
      await Apiss().purchaseQr(
          Apiss.qr_idpayment, "499", "ios_purchase", Apiss.qr_redirecturl);
      Apiss().listmyqrs();
      Apiss().getAllqrs("");
      print("shoudl get successfful purchase");
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/myqrs', (Route<dynamic> route) => false);
      }
    }
  }
}
