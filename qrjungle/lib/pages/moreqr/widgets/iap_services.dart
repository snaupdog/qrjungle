import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qrjungle/models/apiss.dart';

class IAPService {
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
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        print("Purchase marked complete");
      }
    });
  }

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == 'buy_qrcode') {
      await Apiss().purchaseQr("ZZnm", "399", "", "https://sniapdog.com");
      print("shoudl succesfull get order id");
    }
  }
}
