import 'package:get/get.dart';

class IntroController extends GetxController {
  void gotoLoginPage() {
    Get.offNamedUntil('/splash', (route) => false);
  }
}
