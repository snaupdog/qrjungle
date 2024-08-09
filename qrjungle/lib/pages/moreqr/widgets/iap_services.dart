import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:qrjungle/models/apiss.dart';
import 'package:qrjungle/pages/moreqr/moreqr.dart';
import 'package:qrjungle/pages/moreqr/test.dart';

class IAPService {
  final PaymentController paymentController = Get.find();

  IAPService();
  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print("purchaseDetails.status ${purchaseDetails.status}");
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        _handleSuccessfulPurchase(purchaseDetails);
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        print(purchaseDetails.error!);
        paymentloading.value = false;
        print("Hello");
      }

      if (purchaseDetails.pendingCompletePurchase) {
        paymentloading.value = false;
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        print("Purchase marked complete");
      }
    });
  }

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == 'qrcodeart') {
      await Apiss().purchaseQr(
          Apiss.qr_idpayment, "499", "ios_purchase", Apiss.qr_redirecturl);
      await Apiss().listmyqrs();
      print("shoudl get successfful purchase");
      paymentController.setPaymentLoading(false);
    }
  }
}
