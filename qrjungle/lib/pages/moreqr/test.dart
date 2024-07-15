import 'package:get/get.dart';

class PaymentController extends GetxController {
  var paymentLoading = false.obs;

  void setPaymentLoading(bool value) {
    paymentLoading.value = value;
  }
}
